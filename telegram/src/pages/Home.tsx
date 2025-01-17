export default function Home({
  handleConnectButton,
}: {
  handleConnectButton: () => Promise<void>;
}) {
  return (
    <div className="flex flex-col items-center justify-center min-h-screen bg-gradient-to-b from-gray-900 to-gray-800 text-white">
      <h1 className="text-4xl font-bold text-yellow-400 drop-shadow-lg mt-8">
        Unleash Chaos in Seth's Lottery
      </h1>
      <p className="pt-4 text-lg text-gray-300 max-w-xl text-center">
        Step into the game of fate, where Seth reigns supreme. Are you ready to
        challenge destiny?
      </p>
      <img
        src="/egyptian_god.svg"
        alt="Egyptian God Seth"
        className="mt-6 w-72 drop-shadow-md"
      />
      <div className="grid grid-cols-1 pt-8">
        <button
          className="py-3 px-6 rounded-lg bg-yellow-500 hover:bg-yellow-600 text-gray-900 font-semibold shadow-md w-80 transition-transform transform hover:scale-105"
          onClick={handleConnectButton}
        >
          Connect
        </button>
      </div>
    </div>
  );
}
