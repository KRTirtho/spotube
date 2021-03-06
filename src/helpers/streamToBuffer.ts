import { Stream } from "stream";

export function streamToBuffer(stream: Stream): Promise<Buffer> {
    const buffArr: Uint8Array[] = [];
    return new Promise((resolve, reject) => {
        stream.on("data", (data) => {
            buffArr.push(data);
        });
        stream.on("end", async () => {
            resolve(Buffer.concat(buffArr));
        });
        stream.on("error", (error) => {
            reject(error);
        });
    });
}
