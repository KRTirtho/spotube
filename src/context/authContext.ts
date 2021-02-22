import React, { Dispatch, SetStateAction } from "react";

export interface AuthContext {
  isLoggedIn: boolean;
  setIsLoggedIn: Dispatch<SetStateAction<boolean>>;
  clientId: string;
  clientSecret: string;
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
  setExpires_in: (arg: number)=>void;
  setAccess_token: Dispatch<SetStateAction<string>>;
}

const authContext = React.createContext<AuthContext>({
  isLoggedIn: false,
  setIsLoggedIn() {},
  access_token: "",
  expires_in: 0,
  clientId: "",
  clientSecret: "",
  setExpires_in() {},
  setAccess_token() {},
});

export default authContext;
