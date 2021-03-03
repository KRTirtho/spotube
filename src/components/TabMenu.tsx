import React from "react";
import {Route} from "react-router"
import {View, Button} from "@nodegui/react-nodegui"
import {QIcon} from "@nodegui/nodegui"

function TabMenu(){
  return  (
    <View id="tabmenu" styleSheet={tabBarStylesheet}>
      <TabMenuItem title="Browse"/>
      <TabMenuItem title="Library"/>
      <TabMenuItem title="Currently Playing"/>
    </View>
  )
}

const tabBarStylesheet = `  
  #tabmenu{
    flex-direction: 'column';
    align-items: 'center';
    max-width: 225px;
  }
  #tabmenu-item{
    background-color: transparent;
  }
  #tabmenu-item:hover{
    color: green;
  }
  #tabmenu-item:active{
    color: #59ff88;
  }
`

export default TabMenu;

interface TabMenuItemProps{
  title: string;
  /**
   * path to the icon in string
   */
  icon?: string;
}

export function TabMenuItem({icon, title}:TabMenuItemProps){
  return (
    <Button id="tabmenu-item" text={title}/>
  )
}