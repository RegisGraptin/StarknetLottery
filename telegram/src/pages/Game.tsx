import LotteryGrid from "../components/Lottery";

export default function Game({
  address,
  handleClearSessionButton,
  submitLotteryTicket,
}: {
  address: string;
  handleClearSessionButton: () => Promise<void>;
  submitLotteryTicket: (ticket: Ticket) => Promise<void>;
}) {
  return (
    <div className="min-h-screen bg-gradient-to-b from-gray-900 to-gray-800 text-white p-6">
      <div className="flex justify-between items-center mb-6">
        <p className="text-yellow-400 text-sm font-mono">
          Account Address:{" "}
          <code className="text-yellow-300">
            {address.slice(0, 6)}...{address.slice(-4)}
          </code>
        </p>
        <button
          className="py-2 px-4 text-sm rounded-lg bg-yellow-600 hover:bg-yellow-700 text-black font-semibold shadow-md 
          transition-transform transform hover:scale-105"
          onClick={handleClearSessionButton}
        >
          Disconnect
        </button>
      </div>
      <LotteryGrid submitLotteryTicket={submitLotteryTicket} />
    </div>
  );
}
