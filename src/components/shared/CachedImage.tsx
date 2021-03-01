import React, { useEffect, useRef, useState } from "react";
import { Image, Text, View } from "@nodegui/react-nodegui";
import { QLabel } from "@nodegui/nodegui";
import { ImageProps } from "@nodegui/react-nodegui/dist/components/Image/RNImage";
import { getCachedImageBuffer } from "../../helpers/getCachedImageBuffer";
import showError from "../../helpers/showError";

interface CachedImageProps extends Omit<ImageProps, "buffer"> {
  src: string;
  alt?: string;
}

function CachedImage({ src, alt, ...props }: CachedImageProps) {
  const imgRef = useRef<QLabel>();
  const [imageBuffer, setImageBuffer] = useState<Buffer>();
  const [imageProcessError, setImageProcessError] = useState<boolean>(false);

  useEffect(() => {
    if (imageBuffer===undefined) {
      getCachedImageBuffer(src, props.maxSize ?? props.size)
        .then((buffer) => setImageBuffer(buffer))
        .catch((error) => {
          setImageProcessError(false);
          showError(error, "[Cached Image Error]: ");
        });
    }

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
