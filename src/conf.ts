import dotenv from "dotenv"
import { join } from "path";

const env = dotenv.config({path: join(process.cwd(), ".env")}).parsed as any
export const clientId = "";
export const redirectURI = "http://localhost:4304/auth/spotify/callback"
