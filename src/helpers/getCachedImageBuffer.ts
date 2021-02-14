import path from "path";
import isUrl from "is-url";
import * as fs from "fs"
import axios from "axios";
import { Stream } from "stream";
import { streamToBuffer } from "./streamToBuffer";
import sharp from "sharp";
import du from "du";

interface ImageDimensions {
  height: number;
  width: number;
}

const fsm = fs.promises;

export async function getCachedImageBuffer(name: string, dims?: ImageDimensions): Promise<Buffer> {
  try {
    const MB_5 = 5000000; //5 Megabytes
    const cacheFolder = path.join(process.cwd(), "cache", "images");
    // for clearing up the cache if it reaches out of the size
    const cacheName = `${isUrl(name) ? name.split("/").slice(-1)[0] : name}.cnim`;
    const cachePath = path.join(cacheFolder, cacheName);
    // checking if the cached image already exists or not
    if (fs.existsSync(cachePath)) {
      // automatically removing cache after a certain 50 MB oversize
      if ((await du(cacheFolder)) > MB_5) {
        fs.rmSync(cacheFolder, { recursive: true, force: true });
      }
      const cachedImg = await fsm.readFile(cachePath);
      const cachedImgMeta = await sharp(cachedImg).metadata();

      // if the dimensions are changed then the previously cached
      // images are removed and replaced with a new one
      if (dims && (cachedImgMeta.height !== dims.height || cachedImgMeta.width !== dims?.width)) {
        fs.rmSync(cachePath);
        return await imageResizeAndWrite(cachedImg, { cacheFolder, cacheName, dims });
      }
      return cachedImg;
    } else {
      // finding no cache image fetching it through axios
      const { data: imgData } = await axios.get<Stream>(name, { responseType: "stream" });
      // converting axios stream to buffer
      const resImgBuf = await streamToBuffer(imgData);
      // creating cache_dir
      await fsm.mkdir(cacheFolder, { recursive: true });
      if (dims) {
        return await imageResizeAndWrite(resImgBuf, { cacheFolder, cacheName, dims });
      }
      await fsm.writeFile(path.join(cacheFolder, cacheName), resImgBuf);
      return resImgBuf;
    }
  } catch (error) {
    console.error("[Error in Image Cache]: ", error);
    throw error;
  }
}

async function imageResizeAndWrite(img: Buffer, { cacheFolder, cacheName, dims }: { dims: ImageDimensions; cacheFolder: string; cacheName: string }): Promise<Buffer> {
  // caching the images by resizing if the max/fixed (Width/Height)
  // is available in the args
  const resizedImg = await sharp(img).resize(dims.width, dims.height).toBuffer();
  await fsm.writeFile(path.join(cacheFolder, cacheName), resizedImg);
  return resizedImg;
}
