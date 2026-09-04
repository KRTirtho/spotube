/*
 * Copyright (C) 2026 Kingkor Roy Tirtho and Spotube Contributors
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

use std::sync::Arc;
use std::time::Duration;

use parking_lot::Mutex;
use rtc::ice::mdns::MulticastDnsMode;
use rtc::peer_connection::configuration::interceptor_registry::register_default_interceptors;
use rtc::peer_connection::configuration::setting_engine::SettingEngine;
use webrtc::data_channel::{DataChannel, DataChannelEvent, RTCDataChannelInit};
use webrtc::peer_connection::{
    MediaEngine, PeerConnection, PeerConnectionBuilder, PeerConnectionEventHandler,
    RTCConfigurationBuilder, RTCIceGatheringState, RTCIceServer, RTCPeerConnectionIceEvent,
    RTCPeerConnectionState, RTCSessionDescription, Registry,
};
use webrtc::runtime::channel;

#[derive(Debug, thiserror::Error, uniffi::Error)]
pub enum WebrtcError {
    #[error("SDP error: {reason}")]
    SdpError { reason: String },
    #[error("Connection error: {reason}")]
    ConnectionError { reason: String },
    #[error("Data channel error: {reason}")]
    DataChannelError { reason: String },
    #[error("Invalid state: {reason}")]
    InvalidState { reason: String },
    #[error("Internal error: {reason}")]
    Internal { reason: String },
}

impl From<webrtc::error::Error> for WebrtcError {
    fn from(e: webrtc::error::Error) -> Self {
        WebrtcError::Internal {
            reason: format!("{e:?}"),
        }
    }
}

#[derive(uniffi::Record)]
pub struct IceServerConfig {
    pub urls: Vec<String>,
    pub username: String,
    pub credential: String,
}

#[uniffi::export(callback_interface)]
pub trait WebrtcEventHandler: Send + Sync + 'static {
    fn on_ice_candidate(&self, candidate: String);
    fn on_ice_gathering_state_change(&self, state: String);
    fn on_connection_state_change(&self, state: String);
    fn on_data_channel_open(&self, label: String);
    fn on_data_channel_message(&self, label: String, data: String);
    fn on_data_channel_close(&self, label: String);
}

struct DataChannelEntry {
    dc: Arc<dyn DataChannel>,
    label: String,
}

#[derive(uniffi::Object)]
pub struct WebrtcPeerConnection {
    pc: Arc<dyn PeerConnection>,
    handler: Arc<dyn WebrtcEventHandler>,
    channels: Mutex<Vec<DataChannelEntry>>,
    gather_rx: Mutex<webrtc::runtime::Receiver<()>>,
}

#[uniffi::export(async_runtime = "tokio")]
pub async fn create_webrtc_peer_connection(
    ice_servers: Vec<IceServerConfig>,
    handler: Box<dyn WebrtcEventHandler>,
) -> Result<Arc<WebrtcPeerConnection>, WebrtcError> {
    let handler: Arc<dyn WebrtcEventHandler> = Arc::from(handler);

    let mut media_engine = MediaEngine::default();
    media_engine
        .register_default_codecs()
        .map_err(|e| WebrtcError::Internal {
            reason: format!("media_engine: {e:?}"),
        })?;

    let registry = register_default_interceptors(Registry::new(), &mut media_engine)
        .map_err(|e| WebrtcError::Internal {
            reason: format!("interceptor_registry: {e:?}"),
        })?;

    let config = RTCConfigurationBuilder::new()
        .with_ice_servers(
            ice_servers
                .into_iter()
                .map(|s| RTCIceServer {
                    urls: s.urls,
                    username: s.username,
                    credential: s.credential,
                })
                .collect(),
        )
        .build();

    // mDNS adds a multicast UDP socket per peer connection. On some platforms
    // (notably Android) that socket can stall and ICE gathering then never
    // completes. Real-IP host candidates (no mDNS) work fine alongside STUN/TURN,
    // so mDNS is disabled.
    let mut setting_engine = SettingEngine::default();
    setting_engine.set_multicast_dns_mode(MulticastDnsMode::Disabled);

    let (gather_tx, gather_rx) = channel::<()>(1);
    let pc_handler = Arc::new(PeerHandlerBridge {
        handler: Arc::clone(&handler),
        gather_tx,
    });

    let pc = PeerConnectionBuilder::new()
        .with_configuration(config)
        .with_setting_engine(setting_engine)
        .with_media_engine(media_engine)
        .with_interceptor_registry(registry)
        .with_handler(pc_handler)
        .with_udp_addrs(vec!["0.0.0.0:0"])
        .build()
        .await?;

    Ok(Arc::new(WebrtcPeerConnection {
        pc: Arc::new(pc) as Arc<dyn PeerConnection>,
        handler,
        channels: Mutex::new(Vec::new()),
        gather_rx: Mutex::new(gather_rx),
    }))
}

impl WebrtcPeerConnection {
    /// Waits for ICE gathering to reach `Complete` so the local SDP includes all
    /// candidates (non-trickle exchange). Must be called after `set_local_description`,
    /// which is what starts gathering.
    ///
    /// Bounded by a timeout so a stalled gatherer (e.g. a platform that never reports
    /// completion) can never hang `create_offer`/`create_answer` forever — the SDP
    /// with the candidates gathered so far is returned instead.
    async fn wait_for_ice_gathering(&self) {
        let mut gather_rx = self.gather_rx.lock().clone();
        match tokio::time::timeout(Duration::from_secs(5), gather_rx.recv()).await {
            Ok(_) => {}
            Err(_) => {
                log::warn!(
                    "ICE gathering did not complete within 5s; returning SDP with the candidates gathered so far"
                );
            }
        }
    }
}

#[uniffi::export]
impl WebrtcPeerConnection {
    #[uniffi::method(async_runtime = "tokio")]
    pub async fn create_offer(&self) -> Result<String, WebrtcError> {
        let offer = self.pc.create_offer(None).await?;
        self.pc.set_local_description(offer.clone()).await?;
        self.wait_for_ice_gathering().await;
        Ok(self.pc.local_description().await.map(|d| d.sdp).unwrap_or(offer.sdp))
    }

    #[uniffi::method(async_runtime = "tokio")]
    pub async fn create_answer(&self) -> Result<String, WebrtcError> {
        let answer = self.pc.create_answer(None).await?;
        self.pc.set_local_description(answer.clone()).await?;
        self.wait_for_ice_gathering().await;
        Ok(self.pc.local_description().await.map(|d| d.sdp).unwrap_or(answer.sdp))
    }

    #[uniffi::method(async_runtime = "tokio")]
    pub async fn set_remote_offer(&self, sdp: String) -> Result<(), WebrtcError> {
        let desc = RTCSessionDescription::offer(sdp)
            .map_err(|e| WebrtcError::SdpError { reason: format!("{e:?}") })?;
        self.pc.set_remote_description(desc).await?;
        Ok(())
    }

    #[uniffi::method(async_runtime = "tokio")]
    pub async fn set_remote_answer(&self, sdp: String) -> Result<(), WebrtcError> {
        let desc = RTCSessionDescription::answer(sdp)
            .map_err(|e| WebrtcError::SdpError { reason: format!("{e:?}") })?;
        self.pc.set_remote_description(desc).await?;
        Ok(())
    }

    #[uniffi::method(async_runtime = "tokio")]
    pub async fn local_description(&self) -> Option<String> {
        self.pc.local_description().await.map(|d| d.sdp)
    }

    #[uniffi::method(async_runtime = "tokio")]
    pub async fn create_data_channel(&self, label: String) -> Result<(), WebrtcError> {
        let dc = self
            .pc
            .create_data_channel(&label, None::<RTCDataChannelInit>)
            .await?;

        spawn_data_channel_poll_loop(Arc::clone(&dc), Arc::clone(&self.handler));

        self.channels.lock().push(DataChannelEntry { dc, label });
        Ok(())
    }

    #[uniffi::method(async_runtime = "tokio")]
    pub async fn send_data(&self, label: String, data: String) -> Result<(), WebrtcError> {
        let dc = {
            let channels = self.channels.lock();
            channels
                .iter()
                .find(|c| c.label == label)
                .map(|c| Arc::clone(&c.dc))
        };
        let dc = dc.ok_or_else(|| WebrtcError::InvalidState {
            reason: format!("No data channel with label '{label}'"),
        })?;
        dc.send_text(&data).await?;
        Ok(())
    }

    #[uniffi::method(async_runtime = "tokio")]
    pub async fn shutdown(&self) -> Result<(), WebrtcError> {
        let channels: Vec<Arc<dyn DataChannel>> = {
            let channels = self.channels.lock();
            channels.iter().map(|c| Arc::clone(&c.dc)).collect()
        };
        for dc in channels.iter() {
            let _ = dc.close().await;
        }
        self.pc.close().await?;
        Ok(())
    }
}

struct PeerHandlerBridge {
    handler: Arc<dyn WebrtcEventHandler>,
    gather_tx: webrtc::runtime::Sender<()>,
}

#[async_trait::async_trait]
impl PeerConnectionEventHandler for PeerHandlerBridge {
    async fn on_ice_candidate(&self, event: RTCPeerConnectionIceEvent) {
        self.handler.on_ice_candidate(event.candidate.to_string());
    }

    async fn on_ice_gathering_state_change(&self, state: RTCIceGatheringState) {
        let s = state.to_string();
        if matches!(state, RTCIceGatheringState::Complete) {
            let _ = self.gather_tx.try_send(());
        }
        self.handler.on_ice_gathering_state_change(s);
    }

    async fn on_connection_state_change(&self, state: RTCPeerConnectionState) {
        self.handler.on_connection_state_change(state.to_string());
    }

    async fn on_data_channel(&self, dc: Arc<dyn DataChannel>) {
        spawn_data_channel_poll_loop(dc, Arc::clone(&self.handler));
    }
}

fn spawn_data_channel_poll_loop(
    dc: Arc<dyn DataChannel>,
    handler: Arc<dyn WebrtcEventHandler>,
) {
    ::tokio::spawn(async move {
        let label = match dc.label().await {
            Ok(l) => l,
            Err(_) => return,
        };
        while let Some(event) = dc.poll().await {
            match event {
                DataChannelEvent::OnOpen => {
                    handler.on_data_channel_open(label.clone());
                }
                DataChannelEvent::OnMessage(msg) => {
                    let text = if msg.is_string {
                        String::from_utf8_lossy(&msg.data).into_owned()
                    } else {
                        format!("[binary:{}bytes]", msg.data.len())
                    };
                    handler.on_data_channel_message(label.clone(), text);
                }
                DataChannelEvent::OnClose | DataChannelEvent::OnClosing => {
                    handler.on_data_channel_close(label.clone());
                    if matches!(event, DataChannelEvent::OnClose) {
                        break;
                    }
                }
                _ => {}
            }
        }
    });
}