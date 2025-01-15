import { useState } from "react";

export default function LotteryGrid() {
  const [numbers, setNumbers] = useState<number[]>([]);

  function selectNumber(number: number) {
    // Remove the item
    if (numbers.includes(number)) {
      const index = numbers.indexOf(number);
      setNumbers([...numbers.slice(0, index), ...numbers.slice(index + 1)]);
    } else {
      // Add the item
      if (numbers.length == 5) {
        return;
      }
      setNumbers([...numbers, number]);
    }
  }

  function createCellStyle(number: number) {
    let base = `p-4 w-14 h-14 shadow-lg rounded-lg my-1 mx-1`;

    if (numbers.includes(number)) {
      base += " bg-red-600";
    } else {
      base += " bg-sky-500 hover:bg-sky-400";
    }
    return base;
  }

  const sumbitNumbers = () => {
    console.log("test");
  };

  return (
    <>
      <div className="w-max mx-auto pt-5">
        {Array.from({ length: 10 }).map((_, rowId) => {
          return (
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
          );
        })}

        <div className="pt-5">
          <button
            type="button"
            className="text-white bg-blue-700 hover:bg-blue-800 focus:ring-4 focus:ring-blue-300 font-medium rounded-lg text-sm px-5 py-2.5 me-2 mb-2 dark:bg-blue-600 dark:hover:bg-blue-700 focus:outline-none dark:focus:ring-blue-800"
            disabled={numbers.length != 5}
            onClick={sumbitNumbers}
          >
            Validate
          </button>
        </div>
      </div>
    </>
  );
}
