import React, { Dispatch, SetStateAction } from "react";


export interface AuthContext {
  isLoggedIn: boolean;
  setIsLoggedIn: Dispatch<SetStateAction<boolean>>;
  access_token: string
}

const authContext = React.createContext<AuthContext>({
  isLoggedIn: false,
  setIsLoggedIn() {},
  access_token: ""
});

export default authContext;
