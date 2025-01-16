import { useState } from 'react'
import './App.css'



import { SessionAccountInterface } from '@argent/tma-wallet'
import LotteryGrid from './components/Lottery';
import { isTMA } from '@telegram-apps/sdk';
import Home from './pages/Home';

// // FIXME: create lib file
// const argentTMA = ArgentTMA.init({
//   environment: "sepolia", 
//   appName: "SethLottery",
//   appTelegramUrl: import.meta.env.VITE_TELEGRAM_URL,
//   sessionParams: {
//     allowedMethods: [
//       // List of contracts/methods allowed to be called by the session key
//       // {
//       //   contract: "contracts address",
//       //   selector: "function name",
//       // }
//     ],
//     validityDays: 90 // session validity (in days) - default: 90
//   },
// });

function App() {


  

  const [account, setAccount] = useState<SessionAccountInterface | undefined>();
  const [isConnected, _setIsConnected] = useState<boolean>(false);


  // useEffect(() => {

    // Call connect() as soon as the app is loaded
  //   argentTMA
  //     .connect()
  //     .then((res) => {
  //       if (!res) {
  //         // Not connected
  //         setIsConnected(false);
  //         return;
  //       }

  //       // Connected
  //       const { account, callbackData } = res;

  //       if (account.getSessionStatus() !== "VALID") {
  //         // Session has expired or scope (allowed methods) has changed
  //         // A new connection request should be triggered
          
  //         // The account object is still available to get access to user's address
  //         // but transactions can't be executed
  //         const { account } = res;

  //         setAccount(account);
  //         setIsConnected(false);
  //         return;
  //       }

  //       // Connected
  //       // const { account, callbackData } = res;
  //       // The session account is returned and can be used to submit transactions
  //       setAccount(account);
  //       setIsConnected(true);
  //       // Custom data passed to the requestConnection() method is available here
  //       console.log("callback data:", callbackData);
  //     })
  //     .catch((err) => {
  //       console.error("Failed to connect", err);
  //     });
  // }, []);

  const handleConnectButton = async () => {

    console.log("Here we go!")

    if (await isTMA()) {
      // TODO:: Use argent wallet for telegram version

    } else {
      // Use browser wallet

    }

    // If not connected, trigger a connection request
    // It will open the wallet and ask the user to approve the connection
    // The wallet will redirect back to the app and the account will be available
    // from the connect() method -- see above
    // await argentTMA.requestConnection({});
  };

  // // useful for debugging
  const handleClearSessionButton = async () => {
    // await argentTMA.clearSession();
    setAccount(undefined);
  };

  console.log(account)
  

  // 1. Home Page

  return (
    <div className="h-auto w-96">

      {!isConnected && <Home handleConnectButton={handleConnectButton} />}
      

      <div className="p-4">
        
        {isConnected && (
          <div>
          <h1>Welcome to the app</h1>
          <div className="flex justify-between items-center w-full">
            
            <p className="text-green-500 text-[12px]">
              Account address: <code>{account?.address.slice(0, 12)} ...</code>
            </p>
            <button className="text-sm p-2 bg-white rounded-lg bg-tomato-300 " onClick={handleClearSessionButton}>Clear Session</button>


          </div>
          
          <LotteryGrid />
          </div>
        )}
      </div>
    </div>
  );
}

export default App;
