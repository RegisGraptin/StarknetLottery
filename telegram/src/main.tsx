import React from "react";
import ReactDOM from "react-dom/client";
import App from "./App.tsx";
import "./index.css";

import WebApp from "@twa-dev/sdk";
import { StarknetProvider } from "./components/starknet-provider.tsx";

WebApp.ready();

ReactDOM.createRoot(document.getElementById("root")!).render(
  <React.StrictMode>
    <StarknetProvider>
      <App />
    </StarknetProvider>
  </React.StrictMode>,
);
