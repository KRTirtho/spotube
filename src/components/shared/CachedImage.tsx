import React, { useEffect, useRef, useState } from "react";
import { Image, Text, View } from "@nodegui/react-nodegui";
import { QLabel } from "@nodegui/nodegui";
import { ImageProps } from "@nodegui/react-nodegui/dist/components/Image/RNImage";
import { getCachedImageBuffer } from "../../helpers/getCachedImageBuffer";

interface CachedImageProps extends Omit<ImageProps, "buffer"> {
  src: string;
  alt?: string;
}

function CachedImage({ src, alt, ...props }: CachedImageProps) {
  const imgRef = useRef<QLabel>();
  const [imageBuffer, setImageBuffer] = useState<Buffer>();
  const [imageProcessError, setImageProcessError] = useState<boolean>(false);

  useEffect(() => {
    (async () => {
      try {
        setImageBuffer(await getCachedImageBuffer(src, props.maxSize ?? props.size));
      } catch (error) {
        setImageProcessError(false);
        console.log("Cached Image Error:", error);
      }
    })();
    return () => {
      imgRef.current?.close();
    };
  }, []);
  return !imageProcessError && imageBuffer ? (
    <Image ref={imgRef} buffer={imageBuffer} {...props} />
  ) : alt ? (
    <View style={`padding: ${((props.maxSize ?? props.size)?.height || 10) / 2.5}px ${((props.maxSize ?? props.size)?.width || 10) / 2.5}px;`}>
      <Text>{alt}</Text>
    </View>
  ) : (
    <></>
  );
}

export default CachedImage;
