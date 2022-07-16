/* @refresh reload */
import { render } from "solid-js/web";

import "./index.css";
import App from "./App";
import { HopeProvider } from "@hope-ui/solid";

render(
  () => (
    <HopeProvider
      config={{
        lightTheme: {
          colors: {
            primary1: "#ffffff",
            primary2: "#e8f8ee",
            primary3: "#bbeacc",
            primary4: "#a5e3bb",
            primary5: "#8edcaa",
            primary6: "#61ce87",
            primary7: "#4ac776",
            primary8: "#34c065",
            primary9: "#1aa74c",
            primary10: "#179443",
            primary11: "#116f32",
            primary12: "#093719",
          },
        },
        initialColorMode: "system",
      }}
    >
      <App />
    </HopeProvider>
  ),
  document.getElementById("root") as HTMLElement
);
