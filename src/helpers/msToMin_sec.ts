export function msToMinAndSec(ms: number) {
    const minutes = Math.floor(ms / 60000);
    const seconds: number = parseInt(((ms % 60000) / 1000).toFixed(0));
    return minutes + ":" + (seconds < 10 ? "0" : "") + seconds;
}
