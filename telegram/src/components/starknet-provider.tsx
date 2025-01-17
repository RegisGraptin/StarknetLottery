"use client";
import React from "react";

import { InjectedConnector } from "starknetkit/injected";
import { WebWalletConnector } from "starknetkit/webwallet";

import { sepolia } from "@starknet-react/chains";
import { StarknetConfig, publicProvider, voyager } from "@starknet-react/core";

export function StarknetProvider({ children }: { children: React.ReactNode }) {
  const connectors = [
    new InjectedConnector({ options: { id: "argentX", name: "Argent X" } }),
    new InjectedConnector({ options: { id: "braavos", name: "Braavos" } }),
    new WebWalletConnector({ url: "https://web.argent.xyz" }),
    // new ArgentMobileConnector(),
  ];

  return (
    <StarknetConfig
      chains={[sepolia]}
      provider={publicProvider()}
      connectors={connectors}
      explorer={voyager}
    >
      {children}
    </StarknetConfig>
  );
}
