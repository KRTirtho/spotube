import React, { useEffect, useRef, useState } from "react";
import { Text, View } from "@nodegui/react-nodegui";
import { QLabel, QPixmap } from "@nodegui/nodegui";
import { ImageProps } from "@nodegui/react-nodegui/dist/components/Image/RNImage";
import { getCachedImageBuffer } from "../../helpers/getCachedImageBuffer";
import showError from "../../helpers/showError";

interface CachedImageProps extends Omit<ImageProps, "buffer"> {
    src: string;
    alt?: string;
}

function CachedImage({ src, alt, size, maxSize, ...props }: CachedImageProps) {
    const labelRef = useRef<QLabel>();
    const [imageBuffer, setImageBuffer] = useState<Buffer>();
    const [imageProcessError, setImageProcessError] = useState<boolean>(false);
    const pixmap = new QPixmap();

    useEffect(() => {
        if (imageBuffer === undefined) {
            getCachedImageBuffer(src, maxSize ?? size)
                .then((buffer) => setImageBuffer(buffer))
                .catch((error) => {
                    setImageProcessError(false);
                    showError(error, "[Cached Image Error]: ");
                });
        }

        return () => {
            labelRef.current?.close();
        };
    }, []);

    useEffect(() => {
        if (imageBuffer) {
            pixmap.loadFromData(imageBuffer);
            pixmap.scaled(
                (size ?? maxSize)?.height ?? 100,
                (size ?? maxSize)?.width ?? 100,
            );
            labelRef.current?.setPixmap(pixmap);
        }
    }, [imageBuffer]);

    return !imageProcessError && imageBuffer ? (
        <Text ref={labelRef} {...props} />
    ) : alt ? (
        <View
            style={`padding: ${((maxSize ?? size)?.height || 10) / 2.5}px ${
                ((maxSize ?? size)?.width || 10) / 2.5
            }px;`}
        >
            <Text>{alt}</Text>
        </View>
    ) : (
        <></>
    );
}

export default CachedImage;
