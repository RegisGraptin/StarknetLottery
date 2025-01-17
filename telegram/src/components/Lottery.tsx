import { useState } from "react";

export default function LotteryGrid({
  submitLotteryTicket,
}: {
  submitLotteryTicket: (ticket: Ticket) => Promise<void>;
}) {
  const [numbers, setNumbers] = useState<number[]>([]);

  const selectNumber = (number: number) => {
    if (numbers.includes(number)) {
      setNumbers(numbers.filter((n) => n !== number));
    } else if (numbers.length < 5) {
      setNumbers([...numbers, number]);
    }
  };

  const createCellStyle = (number: number) => {
    return `p-4 w-14 h-14 shadow-lg rounded-lg m-1 text-lg font-bold text-center cursor-pointer 
      ${
        numbers.includes(number)
          ? "bg-yellow-600 text-black"
          : "bg-gray-700 text-yellow-300 hover:bg-yellow-500"
      } transition-all duration-300`;
  };

  const submitNumbers = async () => {
    const sortedNumbers = numbers.sort((a, b) => a - b);
    const ticket: Ticket = {
      num1: sortedNumbers[0],
      num2: sortedNumbers[1],
      num3: sortedNumbers[2],
      num4: sortedNumbers[3],
      num5: sortedNumbers[4],
    };

    await submitLotteryTicket(ticket);
  };

  return (
    <div className="flex flex-col items-center">
      <h2 className="text-4xl font-extrabold text-yellow-400 my-5">
        Choose Your Fate!
      </h2>
      <div className="grid grid-rows-10 gap-2">
        {Array.from({ length: 10 }).map((_, rowId) => (
          <div key={rowId} className="flex">
            {Array.from({ length: 5 }).map((_, cellId) => {
              const number = rowId * 5 + cellId + 1;
              return (
                <div
                  key={cellId}
                  className={createCellStyle(number)}
                  onClick={() => selectNumber(number)}
                >
                  {number}
                </div>
              );
            })}
          </div>
        ))}
      </div>
      <div className="pt-5">
        <button
          type="button"
          className={`text-black font-semibold rounded-lg text-sm px-5 py-2.5 
            ${
              numbers.length === 5
                ? "bg-yellow-500 hover:bg-yellow-600 focus:ring-4 focus:ring-yellow-300"
                : "bg-gray-500 cursor-not-allowed"
            } transition-all`}
          disabled={numbers.length !== 5}
          onClick={submitNumbers}
        >
          {numbers.length === 5
            ? "Seal Your Destiny"
            : "Awaiting Your Choices..."}
        </button>
      </div>
    </div>
  );
}
