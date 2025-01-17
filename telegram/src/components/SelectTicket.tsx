import { useCall } from "@starknet-react/core";

import LotteryStarknetContract from "../abi/contract_LotteryStarknet.contract_class.json";

export default function SelectTicket({ ticket }: { ticket: Ticket }) {
  const LOTTERY_CONTRACT_ADDRESS =
    "0x058ec50072f4cb7587809f2c18cc216ca2c706f22d165128a0c1ca0e22175049";

  const { data } = useCall({
    abi: LotteryStarknetContract.abi,
    address: LOTTERY_CONTRACT_ADDRESS,
    functionName: "last_contest_id",
  });

  console.log(data);

  const numbers = [
    ticket.num1,
    ticket.num2,
    ticket.num3,
    ticket.num4,
    ticket.num5,
  ];

  return (
    <div className="flex flex-col items-center">
      <h2 className="text-4xl font-extrabold text-yellow-400 my-5">
        Choosen Fate!
      </h2>
      <div className="grid grid-rows-10 gap-2">
        <div className="flex">
          {numbers.map((val, cellId) => (
            <div
              key={cellId}
              className="p-4 w-14 h-14 shadow-lg rounded-lg m-1 text-lg font-bold text-center cursor-pointer transition-all duration-300 bg-yellow-600 text-black"
            >
              {val}
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}
