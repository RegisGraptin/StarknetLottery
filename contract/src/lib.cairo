
#[starknet::interface]
pub trait ILotteryStarknet<TContractState> {

    /// Create a new lottery
    fn create_new_contest(ref self: TContractState, end_time_contest: u64);

    /// Buy and join an active contest
    fn buy_ticket(ref self: TContractState, number: u64);

    /// Terminate the contest and distribute prize 
    fn end_contest(ref self: TContractState);

}

/// Simple contract for managing balance.
#[starknet::contract]
mod LotteryStarknet {
    use starknet::{ContractAddress};
    
    use starknet::get_caller_address;
    use starknet::get_contract_address;
    use starknet::contract_address_const;
    use starknet::storage::{
        Map, StorageMapReadAccess, StorageMapWriteAccess, StoragePointerReadAccess,
        StoragePointerWriteAccess,
    };

    use core::starknet::get_block_timestamp;

    use openzeppelin::token::erc20::interface::{IERC20Dispatcher, IERC20DispatcherTrait};


    pub mod Errors {
        pub const NOT_OWNER: felt252 = 'Caller is not the owner';
        pub const UNFINISHED_CONTEST: felt252 = 'The contest is not finished';
        pub const NOT_ONGOING_CONTEST: felt252 = 'The contest is not on going';
        pub const INVALID_TICKET_PRICE: felt252 = 'Invalid ticket price';
        pub const TICKET_ALREADY_BOUGHT: felt252 = 'Ticket has already been bought';
        pub const NOT_ENOUGH_FUNDS: felt252 = 'Not enough funds';
    }

    // IERC20 token address of starknet token
    pub const STARKNET_TOKEN_ADDRESS: felt252 = 0x04718f5a0fc34cc1af16a1cdee98ffb20c31f5cd61d6ab07201858f4287c938d;

    #[derive(Copy, Drop, Serde, starknet::Store)]
    struct Contest {
        pub id: u32,
        pub start_time: u64,
        pub end_time: u64,
        pub price: u256,
    }

    #[storage]
    struct Storage {
        pub owner: ContractAddress,
        pub last_contest_id: u32,
        
        contests: Map::<u32, Contest>,
        tickets: Map::<(u32, u64), ContractAddress>,
    }

    #[constructor]
    fn constructor(ref self: ContractState, owner: ContractAddress) {
        self.owner.write(owner);
    }

    fn assert_only_owner(self: @ContractState) {
        let owner = self.owner.read();
        let caller = get_caller_address();
        assert(caller == owner, Errors::NOT_OWNER);
    }


    #[abi(embed_v0)]
    impl LotteryStarknetImpl of super::ILotteryStarknet<ContractState> {


        fn create_new_contest(ref self: ContractState, end_time_contest: u64) {

            // Let's say the end push the id+1
            // Meaning that each time the end time is not defined
            // We have successfuly push to the next id
            // If not, meaning we are still in the contest or waiting to call the end contest



            // Check if the previous contest is finished
            let lastToken: u32 = self.last_contest_id.read();
            let last_contest: Contest = self.contests.read(lastToken);
            assert(last_contest.end_time == 0, Errors::UNFINISHED_CONTEST);

            // Create a contest at the given id
            self.contests.write(
                self.last_contest_id.read(), 
                Contest { 
                    id: self.last_contest_id.read(), 
                    start_time: get_block_timestamp(),
                    end_time: end_time_contest,
                    price: 10, // FIXME:
                }
            );

        }



        

        fn buy_ticket(ref self: ContractState, number: u64){

            // NOTE: Everything in ERC20 

            // Check the current contest is still ongoing
            let contest_id: u32 = self.last_contest_id.read();
            let current_contest: Contest = self.contests.read(contest_id);
            assert(get_block_timestamp() < current_contest.end_time, Errors::NOT_ONGOING_CONTEST);

            // Check the price match
            let ticket_price = current_contest.price;

            // Check the ticket is still available
            let ticket = self.tickets.read((contest_id, number));
            assert(ticket == contract_address_const::<0>(), Errors::TICKET_ALREADY_BOUGHT);

            // Buy the ticket
            let erc20_dispatcher = IERC20Dispatcher { 
                contract_address: contract_address_const::<STARKNET_TOKEN_ADDRESS>() 
            };
            let success = erc20_dispatcher.transfer_from(get_caller_address(), get_contract_address(), ticket_price);
            assert(success, Errors::NOT_ENOUGH_FUNDS);

            // Assign the ticket to the user
            self.tickets.write((contest_id, number), get_caller_address());
        }


        fn end_contest(ref self: ContractState){

        }

    }
}
