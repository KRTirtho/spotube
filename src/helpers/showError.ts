import { trace } from "../conf";
import chalk from "chalk";

function showError(error: Error | TypeError, message = "[Error]: ") {
    console.error(chalk.red(message), trace ? error : error.message);
}

export default showError;
