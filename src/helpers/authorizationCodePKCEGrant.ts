import axios, { AxiosResponse } from "axios";
import qs from "querystring";
import { redirectURI } from "../conf";

export interface AuthorizationResponse {
  access_token: string;
  token_type: string;
  scope: string;
  expires_in: number;
  refresh_token: string;
}

async function authorizationCodePKCEGrant({ client_id, code, code_verifier }: { code: string; code_verifier: string; client_id: string }): Promise<AxiosResponse<AuthorizationResponse>> {
  const body = {
    client_id,
    code,
    code_verifier,
    redirect_uri: redirectURI,
    grant_type: "authorization_code",
  };

  try {
    const res = await axios.post<AuthorizationResponse>("https://accounts.spotify.com/api/token", qs.stringify(body), {
      headers: {
        "User-Agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.152 Safari/537.36",
        "Content-Type": "application/x-www-form-urlencoded",
      },
    });
    return res;
  } catch (error) {
    throw error;
  }
}

export default authorizationCodePKCEGrant;
