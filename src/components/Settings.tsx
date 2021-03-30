import { Text, View } from "@nodegui/react-nodegui";
import React from "react";
import Switch from "./shared/Switch";

function Settings() {
  return (
    <View style="flex: 1; flex-direction: 'column'; justify-content: 'flex-start';">
      <Text>{`<center><h2>Settings</h2></center>`}</Text>
      <View style="width: '100%'; flex-direction: 'column'; justify-content: 'flex-start';">
        <SettingsCheckTile title="Use images instead of colors for playlist" subtitle="This will increase memory usage" />
        <SettingsCheckTile title="Some unknown settings" />
      </View>
    </View>
  );
}

export default Settings;

interface SettingsCheckTileProps {
  title: string;
  subtitle?: string;
}

export function SettingsCheckTile({ title, subtitle = "" }: SettingsCheckTileProps) {
  return (
    <View style="flex: 1; align-items: 'center'; padding: 15px 0; justify-content: 'space-between';">
      <Text>
        {`
          <b>${title}</b>
          <p>${subtitle}</p>
        `}
      </Text>
      <Switch checked/>
    </View>
  );
}
