import LotteryGrid from "../components/Lottery";

export default function Game({
  address,
  handleClearSessionButton,
}: {
  address: string;
  handleClearSessionButton: () => Promise<void>;
}) {
  return (
    <div className="p-4">
      <div>
        <div className="flex justify-between items-center w-full">
          <p className="text-green-500 text-[12px]">
            Account address:{" "}
            <code>
              {address.slice(0, 6)}...{address.slice(-4)}
            </code>
          </p>
          <button
            className="text-sm p-2 bg-white rounded-lg bg-tomato-300"
            onClick={handleClearSessionButton}
          >
            Clear Session
          </button>
        </div>

        <LotteryGrid />
      </div>
    </div>
  );
}
