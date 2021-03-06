import React, { Dispatch, SetStateAction } from "react";

export interface AuthContext {
  isLoggedIn: boolean;
  setIsLoggedIn: Dispatch<SetStateAction<boolean>>;
  clientId: string;
  clientSecret: string;
  access_token: string;
  setAccess_token: Dispatch<SetStateAction<string>>;
}

const authContext = React.createContext<AuthContext>({
  isLoggedIn: false,
  setIsLoggedIn() {},
  access_token: "",
  clientId: "",
  clientSecret: "",
  setAccess_token() {},
});

export default authContext;
