import color from "color";

export function generateRandomColor(lightness = 70): string {
    return (
        "hsl(" +
        360 * Math.random() +
        "," +
        (25 + 70 * Math.random()) +
        "%," +
        (lightness + 10 * Math.random()) +
        "%)"
    );
}

export function getDarkenForeground(hslcolor: string): string {
    const adjustedColor = color(hslcolor);
    return adjustedColor.darken(0.5).hex();
}
