import { Text, View } from "@nodegui/react-nodegui";
import React, { useContext } from "react";
import preferencesContext from "../context/preferencesContext";
import Switch, { SwitchProps } from "./shared/Switch";

function Settings() {
    const { setPreferences, ...preferences } = useContext(preferencesContext);
    return (
        <View style="flex: 1; flex-direction: 'column'; justify-content: 'flex-start';">
            <Text>{`<center><h2>Settings</h2></center>`}</Text>
            <View style="width: '100%'; flex-direction: 'column'; justify-content: 'flex-start';">
                <SettingsCheckTile
                    checked={preferences.playlistImages}
                    title="Use images instead of colors for playlist"
                    subtitle="This will increase memory usage"
                    onChange={(checked) =>
                        setPreferences({ ...preferences, playlistImages: checked })
                    }
                />
            </View>
        </View>
    );
}

export default Settings;

interface SettingsCheckTileProps {
    title: string;
    subtitle?: string;
    checked: boolean;
    onChange?: SwitchProps["onChange"];
}

export function SettingsCheckTile({
    title,
    subtitle = "",
    onChange,
    checked,
}: SettingsCheckTileProps) {
    return (
        <View style="flex: 1; align-items: 'center'; padding: 15px 0; justify-content: 'space-between';">
            <Text>
                {`
          <b>${title}</b>
          <p>${subtitle}</p>
        `}
            </Text>
            <Switch checked={checked} onChange={onChange} />
        </View>
    );
}
