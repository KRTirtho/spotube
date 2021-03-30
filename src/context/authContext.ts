import React, { Dispatch, SetStateAction } from "react";
import { Credentials } from "../app";

export interface AuthContext {
  isLoggedIn: boolean;
  setIsLoggedIn: Dispatch<SetStateAction<boolean>>;
  clientId: string;
  clientSecret: string;
  access_token: string;
  setCredentials: Dispatch<SetStateAction<Credentials>>
  setAccess_token: Dispatch<SetStateAction<string>>;
}

const authContext = React.createContext<AuthContext>({
  isLoggedIn: false,
  setIsLoggedIn() {},
  access_token: "",
  clientId: "",
  clientSecret: "",
  setCredentials(){},
  setAccess_token() {},
});

export default authContext;
