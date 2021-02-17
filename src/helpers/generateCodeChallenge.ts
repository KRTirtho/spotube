import crypto from "crypto";
import base64url from "base64url";

export function generateCodeChallenge() {
  try {
    const code_verifier = crypto.randomBytes(64).toString("hex");
    const base64Digest = crypto.createHash("sha256").update(code_verifier).digest("base64");
    const code_challenge = base64url.fromBase64(base64Digest);
    return {code_challenge, code_verifier};
  } catch (error) {
    throw error;
  }
}
