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
            primary1: "#d4f3df",
            primary2: "#d4f3df",
            primary3: "#b7ecca",
            primary4: "#9be4b4",
            primary5: "#7edc9f",
            primary6: "#61d48a",
            primary7: "#45cd74",
            primary8: "#32ba62",
            primary9: "#2b9e53",
            primary10: "#238144",
            primary11: "#1b6435",
            primary12: "#134826",
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
