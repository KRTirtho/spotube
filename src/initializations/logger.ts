import winston from "winston";
import chalk from "chalk";
import util from "util";

function safeStringify(arg: string | Record<any, any>): string {
    return typeof arg === "object" ? JSON.stringify(arg, null, 2) : arg;
}

const spotubeLogFormat = winston.format.printf(({ level, message, label, prefix }) => {
    if (!prefix && !label && typeof message === "object") {
        return util.inspect(message, { colors: true, sorted: true, depth: 5 });
    }
    const safeMsg = safeStringify(message);
    const safePrefix = safeStringify(prefix) ?? "";

    const colors = {
        info: "skyblue",
        error: "red",
        debug: "orange",
        warn: "yellow",
    };
    const colorize = chalk.bold.keyword(colors[level as keyof typeof colors]);
    return `${colorize(level)} [${chalk.bold.green(label)}]: ${colorize(
        safePrefix,
    )} ${safeMsg}`;
});

const baseLogger = winston.createLogger({
    level: "info",
    format: winston.format.combine(
        winston.format.prettyPrint({ colorize: true }),
        spotubeLogFormat,
    ),
    transports: [new winston.transports.Console()],
});

type LogMessage = string | Record<any, any> | number;

export class Logger {
    logger: winston.Logger = baseLogger;

    constructor(public module: string, logger?: winston.Logger) {
        if (logger) this.logger = logger;
    }

    log(message: LogMessage, level = "debug", prefix?: LogMessage) {
        if (typeof message === "object") {
            this.logger.log(level, { label: this.module, prefix, message: "" });
            this.logger.log(level, { message });
        } else {
            this.logger.log(level, { label: this.module, message, prefix });
        }
    }

    info(msg: LogMessage, msg2?: LogMessage): void {
        if (msg2) this.log(msg2, "info", msg);
        else this.log(msg, "info");
    }

    warn(msg: LogMessage, msg2?: LogMessage): void {
        if (msg2) this.log(msg2, "warn", msg);
        else this.log(msg, "warn");
    }

    error(msg: LogMessage, msg2?: LogMessage): void {
        if (msg2) this.log(msg2, "error", msg);
        else this.log(msg, "error");
    }

    debug(msg: LogMessage, msg2?: LogMessage): void {
        if (msg2) this.log(msg2, "debug", msg);
        else this.log(msg, "debug");
    }
}
