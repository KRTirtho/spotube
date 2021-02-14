import { QIcon } from "@nodegui/nodegui";
import React, { ReactElement } from "react";
import { useHistory } from "react-router";
import { angleLeft } from "../icons";
import IconButton from "./shared/IconButton";

function BackButton(): ReactElement {
  const history = useHistory();

  return <IconButton style={"align-self: flex-start;"} icon={new QIcon(angleLeft)} on={{ clicked: () => history.goBack() }} />;
}

export default BackButton;
