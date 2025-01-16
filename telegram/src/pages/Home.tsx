

export default function Home({handleConnectButton}:  {handleConnectButton: () => Promise<void>}) {

    return (
        <div className="flex flex-col items-center justify-center">
            <h1>Welcome to Seth Lottery</h1>
            <p>The lottery game of the god, hope you are ready to play with chaos!</p>
            <img src="/egyptian_god.svg" width={300} />
            <div className="grid grid-cols-1">
            <h1>You need to login</h1>
                <button 
                    className="py-2 px-4 rounded-lg bg-slate-300 text-gray-700" 
                    onClick={handleConnectButton}>
                    Connect
                </button>
            </div>

        </div>
    )
}