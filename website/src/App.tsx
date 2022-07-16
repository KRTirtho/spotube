import { VStack } from "@hope-ui/solid";
import type { Component } from "solid-js";
import Navbar from "./components/Navbar";
import { Route, Router, Routes } from "solid-app-router";
import { Root } from "./pages/Root";
import AllVersions from "./pages/AllVersions";

const App: Component = () => {
  return (
    <Router>
      <VStack alignItems="stretch">
        <Navbar />
        <Routes>
          <Route path="/" component={Root} />
          <Route path="/all-versions" component={AllVersions} />
        </Routes>
      </VStack>
    </Router>
  );
};

export default App;
