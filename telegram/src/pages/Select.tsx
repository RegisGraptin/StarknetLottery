import SelectTicket from "../components/SelectTicket";

export default function Select({
  address,
  handleClearSessionButton,
  ticket,
}: {
  address: string;
  handleClearSessionButton: () => Promise<void>;
  ticket: Ticket;
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
      <SelectTicket ticket={ticket} />
    </div>
  );
}
