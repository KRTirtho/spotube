import React from "react";
import { View, Button, Text } from "@nodegui/react-nodegui";
import { useHistory, useLocation } from "react-router";
import { settingsCog } from "../icons";
import IconButton from "./shared/IconButton";
import { QIcon } from "@nodegui/nodegui";

function TabMenu() {
  const history = useHistory();

  return (
    <View id="tabmenu" styleSheet={tabBarStylesheet}>
      <View>
        <Text>{`<h1>Spotube</h1>`}</Text>
      </View>
      <TabMenuItem url="/home" title="Browse" />
      <TabMenuItem url="/library" title="Library" />
      <TabMenuItem url="/currently" title="Currently Playing" />
      <TabMenuItem url="/search" title="Search" />
      <IconButton
        icon={new QIcon(settingsCog)}
        on={{
          clicked() {
            history.push("/settings");
          },
        }}
      />
    </View>
  );
}

export const tabBarStylesheet = `  
  #tabmenu{
    padding: 10px;
    flex-direction: 'row';
    justify-content: 'space-around';
  }
  #tabmenu-item:hover{
    color: green;
  }
  #tabmenu-active-item{
    background-color: green;
    color: white;
  }
`;

export default TabMenu;

export interface TabMenuItemProps {
  title: string;
  url: string;
  /**
   * path to the icon in string
   */
  icon?: string;
}

export function TabMenuItem({ icon, title, url }: TabMenuItemProps) {
  const location = useLocation();
  const history = useHistory();

  function clicked() {
    history.push(url);
  }

  return <Button on={{ clicked }} id={location.pathname.replace("/", " ").startsWith(url.replace("/", " ")) ? "tabmenu-active-item" : `tabmenu-item`} text={title} />;
}
