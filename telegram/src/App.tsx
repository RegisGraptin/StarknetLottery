import { useEffect, useState } from "react";
import "./App.css";
import {
  disconnect,
  StarknetkitConnector,
  useStarknetkitConnectModal,
} from "starknetkit";

import { isTMA } from "@telegram-apps/sdk";
import Home from "./pages/Home";
import Game from "./pages/Game";
import {
  useAccount,
  useConnect,
  useContract,
  useSendTransaction,
} from "@starknet-react/core";

import {} from "@starknet-react/core";

import LotteryStarknetContract from "./abi/contract_LotteryStarknet.contract_class.json";
import StarknetToken from "./abi/erc20_abi.json";
import { ArgentTMA } from "@argent/tma-wallet";
import Select from "./pages/Select";

function App() {
  const { connect, connectors } = useConnect();
  const { starknetkitConnectModal } = useStarknetkitConnectModal({
    connectors: connectors as StarknetkitConnector[],
  });
  const { address, status } = useAccount();

  const [argentTMA, setArgentTMA] = useState<ArgentTMA | undefined>(undefined);

  const [isConnected, setIsConnected] = useState<boolean>(false);
  const [ticket, setTicket] = useState<Ticket>();

  const STARKNET_TOKEN_ADDRESS =
    "0x04718f5a0fc34cc1af16a1cdee98ffb20c31f5cd61d6ab07201858f4287c938d";

  const LOTTERY_CONTRACT_ADDRESS =
    "0x058ec50072f4cb7587809f2c18cc216ca2c706f22d165128a0c1ca0e22175049";

  const { contract: starknetTokenContract } = useContract({
    abi: StarknetToken,
    address: STARKNET_TOKEN_ADDRESS,
  });

  const { contract } = useContract({
    abi: LotteryStarknetContract.abi,
    address: LOTTERY_CONTRACT_ADDRESS,
  });

  const { sendAsync, isSuccess } = useSendTransaction({
    calls:
      contract && starknetTokenContract && ticket
        ? [
            starknetTokenContract.populate("approve", [
              LOTTERY_CONTRACT_ADDRESS,
              10,
            ]),
            contract.populate("buy_ticket", [ticket]),
          ]
        : undefined,
  });

  useEffect(() => {
    if (status === "disconnected") {
      setIsConnected(false);
    } else if (status === "connected") {
      setIsConnected(true);
    }
  }, [address, status]);

  useEffect(() => {
    if (ticket === undefined) {
      return;
    }

    async function sendTicketTransaction() {
      await sendAsync();
      // setTicket(undefined);
      console.log(isSuccess);
    }

    sendTicketTransaction();
  }, [ticket]);

  const handleConnectButton = async () => {
    if (await isTMA()) {
      // TODO:: Use argent wallet for telegram version
      if (argentTMA === undefined) {
        setArgentTMA(
          ArgentTMA.init({
            environment: "sepolia",
            appName: "SethLottery",
            appTelegramUrl: import.meta.env.VITE_TELEGRAM_URL,
            sessionParams: {
              allowedMethods: [
                // List of contracts/methods allowed to be called by the session key
                // {
                //   contract: "contracts address",
                //   selector: "function name",
                // }
              ],
              validityDays: 90, // session validity (in days) - default: 90
            },
          }),
        );
      }
      await argentTMA?.connect();
    } else {
      // Use browser wallet
      const { connector } = await starknetkitConnectModal();
      if (!connector) {
        return;
      }
      await connect({ connector });
    }
  };

  // // useful for debugging
  const handleClearSessionButton = async () => {
    if (await isTMA()) {
      // Use argent wallet for telegram version
      await argentTMA?.clearSession();
    } else {
      setIsConnected(false);
      await disconnect();
    }
  };

  const submitLotteryTicket = async (ticket: Ticket) => {
    console.log(ticket);
    setTicket(ticket);
  };
  return (
    <div className="h-auto w-96">
      {!isConnected && <Home handleConnectButton={handleConnectButton} />}
      {isConnected && address && (
        <>
          {isSuccess && (
            <Select
              address={address}
              handleClearSessionButton={handleClearSessionButton}
              ticket={ticket!}
            />
          )}
          {!isSuccess && (
            <Game
              address={address}
              handleClearSessionButton={handleClearSessionButton}
              submitLotteryTicket={submitLotteryTicket}
            />
          )}
        </>
      )}
    </div>
  );
}

export default App;
