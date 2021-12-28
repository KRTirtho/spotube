import {
    FlexLayout,
    QDialog,
    QLabel,
    QPushButton,
    QScrollArea,
    QWidget,
    TextFormat,
} from "@nodegui/nodegui";
import React, { PropsWithChildren, useEffect, useState } from "react";
import fetchLyrics from "../helpers/fetchLyrics";
import { useLogger } from "../hooks/useLogger";

interface ManualLyricDialogProps extends PropsWithChildren<unknown> {
    open: boolean;
    onClose?: (closed: boolean) => void;
    track: SpotifyApi.TrackObjectSimplified | SpotifyApi.TrackObjectFull;
}

function ManualLyricDialog({ open, track }: ManualLyricDialogProps) {
    const logger = useLogger(ManualLyricDialog.name);

    const dialog = new QDialog();
    const areaContainer = new QWidget();
    const retryButton = new QPushButton();
    const scrollArea = new QScrollArea();
    const titleLabel = new QLabel();
    const lyricLabel = new QLabel();
    const [lyricNotFound, setLyricNotFound] = useState<boolean>(false);
    const [lyrics, setLyrics] = useState<string>("");
    const artists = track.artists.map((artist) => artist.name).join(", ");

    async function handleBtnClick() {
        try {
            const lyrics = await fetchLyrics(artists, track.name);
            logger.info("lyrics", lyrics);
            setLyrics(lyrics);
            setLyricNotFound(lyrics === "Not Found");
        } catch (error: any) {
            logger.error(`Finding lyrics for ${track.name} failed`, error);
            setLyrics("No lyrics found, rare track :)");
            setLyricNotFound(true);
        }
    }

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
        areaContainer.layout?.addWidget(retryButton);
        // scroll area
        scrollArea.setInlineStyle("flex: 1;");
        scrollArea.setWidget(areaContainer);

        // reload button
        retryButton.setText("Retry");
        retryButton.addEventListener("clicked", handleBtnClick);
        // dialog
        dialog.setWindowTitle("Lyrics");
        dialog.setLayout(new FlexLayout());
        dialog.layout?.addWidget(scrollArea);
        open ? dialog.open() : dialog.close();
        open &&
            fetchLyrics(artists, track.name)
                .then((lyrics: string) => {
                    setLyrics(lyrics);
                    setLyricNotFound(lyrics === "Not Found");
                })
                .catch((e: Error) => {
                    logger.error(`Finding lyrics for ${track.name} failed `, e);
                    setLyrics("No lyrics found, rare track :)");
                    setLyricNotFound(true);
                });
        return () => {
            retryButton.removeEventListener("clicked", handleBtnClick);
            dialog.hide();
        };
    }, [open, track, lyrics]);

    useEffect(() => {
        retryButton.setEnabled(!lyricNotFound);
    }, [lyricNotFound]);

    return <></>;
}

export default ManualLyricDialog;
