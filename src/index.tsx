import { Renderer } from "@nodegui/react-nodegui";
import React from "react";
import App from "./app";

process.title = "Spotube";
Renderer.render(<App />, {
  onInit(reconciler) {
    if (process.env.NODE_ENV === "development") {
      require("@nodegui/devtools").connectReactDevtools(reconciler);
    }
  },
});
// This is for hot reloading (this will be stripped off in production by webpack)
if (module.hot) {
  module.hot.accept(["./app"], function () {
    Renderer.forceUpdate();
  });
}
