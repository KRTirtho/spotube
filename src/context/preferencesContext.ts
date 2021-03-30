import React, { Dispatch, SetStateAction } from "react";

export interface PreferencesContextProperties {
  playlistImages: boolean;
}
export interface PreferencesContext extends PreferencesContextProperties {
  setPreferences: Dispatch<SetStateAction<PreferencesContextProperties>>;
}

const preferencesContext = React.createContext<PreferencesContext>({
  playlistImages: false,
  setPreferences() { }
});

export default preferencesContext;
