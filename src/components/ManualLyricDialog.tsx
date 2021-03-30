import { FlexLayout, QDialog, QLabel, QScrollArea, QWidget, TextFormat } from "@nodegui/nodegui";
import React, { PropsWithChildren, useEffect, useState } from "react";
import showError from "../helpers/showError";
import fetchLyrics from "../helpers/fetchLyrics";

interface ManualLyricDialogProps extends PropsWithChildren<{}> {
  open: boolean;
  onClose?: (closed:boolean) => void;
  track: SpotifyApi.TrackObjectSimplified | SpotifyApi.TrackObjectFull;
}

function ManualLyricDialog({ open, track, onClose }: ManualLyricDialogProps) {
  const dialog = new QDialog();
  const areaContainer = new QWidget();
  const scrollArea = new QScrollArea();
  const titleLabel = new QLabel();
  const lyricLabel = new QLabel();
  const [lyrics, setLyrics] = useState<string>("");
  const artists = track.artists.map((artist) => artist.name).join(", ");

  useEffect(() => {
    // title label
    titleLabel.setText(`
      <center>
        <h2>${track.name}</h2>
        <p>- ${artists}</p>
      </center>
    `);
    // lyric label
    lyricLabel.setText(lyrics);
    lyricLabel.setTextFormat(TextFormat.PlainText);
    // area container
    areaContainer.setLayout(new FlexLayout());
    areaContainer.setInlineStyle("flex: 1; flex-direction: 'column'; padding: 10px;");
    areaContainer.layout?.addWidget(titleLabel);
    areaContainer.layout?.addWidget(lyricLabel);
    // scroll area
    scrollArea.setInlineStyle("flex: 1;");
    scrollArea.setWidget(areaContainer);
    // dialog
    dialog.setWindowTitle("Lyrics");
    dialog.setLayout(new FlexLayout());
    dialog.layout?.addWidget(scrollArea);
    open ? dialog.open() : dialog.close();
    open && fetchLyrics(artists, track.name)
      .then((lyrics: string) => {
        setLyrics(lyrics);
      })
      .catch((e: Error) => {
        showError(e, `[Finding lyrics for ${track.name} failed]: `);
        setLyrics("No lyrics found, rare track :)");
      });
    return () => {
      dialog.hide()
    }
  }, [open, track, lyrics]);

  return <></>;
}

export default ManualLyricDialog;
