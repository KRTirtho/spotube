import React, { Dispatch, SetStateAction } from "react";

export interface AuthContext {
  isLoggedIn: boolean;
  setIsLoggedIn: Dispatch<SetStateAction<boolean>>;
  access_token: string;
  /**
   * the time when the current access token will expire \
   * always update this with `Date.now() + expires_in`
   */
  expires_in: number;
  /**
   * sets the time when the current access token will expire \
   * always update this with `Date.now() + expires_in`
   */
  setExpiresIn: Dispatch<SetStateAction<number>>;
  setAccess_token: Dispatch<SetStateAction<string>>;
}

const authContext = React.createContext<AuthContext>({
  isLoggedIn: false,
  setIsLoggedIn() {},
  access_token: "",
  expires_in: 0,
  setExpiresIn() {},
  setAccess_token() {},
});

export default authContext;
