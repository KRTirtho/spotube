import { useMemo } from "react";
import { Logger } from "../initializations/logger";

export function useLogger(module: string) {
    return useMemo(() => new Logger(module), []);
}
