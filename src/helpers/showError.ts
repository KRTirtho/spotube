import { trace } from "../conf";
import chalk from "chalk";

function showError(error: any, message: any="[Error]: ") {
  console.error(chalk.red(message), trace ? error : error.message);
}

export default showError;