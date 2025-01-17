
use alexandria_data_structures::array_ext::ArrayTraitExt;
use alexandria_sorting::BubbleSort;

use starknet::ContractAddress;

use core::poseidon::PoseidonTrait;
use core::hash::{HashStateTrait, HashStateExTrait};

#[derive(Copy, Drop, Serde, starknet::Store, Hash)]
pub struct Ticket {
    pub num1: u8,
    pub num2: u8, 
    pub num3: u8, 
    pub num4: u8,
    pub num5: u8,
}


trait TicketTrait {
    /// We should have 5 different number ordered and contain between [1;50]
    fn verify(self: @Ticket) -> bool;
}

impl TicketImpl of TicketTrait {
    fn verify(self: @Ticket) -> bool {
        // 0 < n1 < n2 < n3 < n4 < n5 < 50
        return (
            @0 < self.num1 
            && self.num1 < self.num2
            && self.num2 < self.num3
            && self.num3 < self.num4
            && self.num4 < self.num5
            && self.num5 < @51
        );
    }
}


fn random_ticket(seed: felt252) -> Ticket {

    let mut numbers: Array<u8> = ArrayTrait::new();
    let mut random_seed = seed;

    while numbers.len() < 5 {
        random_seed = random_seed + 1;
        let hash = PoseidonTrait::new().update_with(random_seed).finalize();
        
        // Number should be between [1;50]
        let reduce_number: u256 = hash.into() % 50;
        let ticket_number: u8 = reduce_number.try_into().unwrap() + 1;

        // Check if the number is unique
        if !numbers.contains(@ticket_number) {
            numbers.append(ticket_number);
        }
    };

    // Sort the number to create the ticket
    let sorted_array = BubbleSort::sort(numbers.into());
    
    return Ticket {
        num1: *sorted_array.at(0),
        num2: *sorted_array.at(1),
        num3: *sorted_array.at(2),
        num4: *sorted_array.at(3),
        num5: *sorted_array.at(4),
    };
}


#[starknet::interface]
pub trait ILotteryStarknet<TContractState> {

    /// Create a new lottery
    fn create_new_contest(ref self: TContractState, end_time_contest: u64);

    /// Buy and join an active contest
    fn buy_ticket(ref self: TContractState, user_ticket: Ticket);

    /// Terminate the contest and distribute prize 
    fn end_contest(ref self: TContractState);


    /// Callback for getting a random number from Pragma Oracle
    fn randomness_callback(
        ref self: TContractState,
        requestor_address: ContractAddress,
        request_id: u64,
        random_words: Span<felt252>,
        calldata: Array<felt252>
    );
}

/// Simple contract for managing balance.
#[starknet::contract]
mod LotteryStarknet {

    use super::{ContractAddress, Ticket, TicketTrait, TicketImpl};
    
    use super::random_ticket;


    use pragma_lib::abi::{IRandomnessDispatcher, IRandomnessDispatcherTrait};

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
        pub const INVALID_TICKET: felt252 = 'Invalid ticket';
        pub const INVALID_TICKET_PRICE: felt252 = 'Invalid ticket price';
        pub const TICKET_ALREADY_BOUGHT: felt252 = 'Ticket has already been bought';
        pub const NOT_ENOUGH_FUNDS: felt252 = 'Not enough funds';
        pub const ALREADY_FINISHED_CONTEST: felt252 = 'Finished contest';
        pub const CONTEST_IS_RUNNING: felt252 = 'Contest is still running';
        pub const TRANSFER_ERROR: felt252 = 'ERC20 transfer error';

    }

    // IERC20 token address of starknet token
    pub const STARKNET_TOKEN_ADDRESS: felt252 = 0x04718f5a0fc34cc1af16a1cdee98ffb20c31f5cd61d6ab07201858f4287c938d;

    // ETH Contract address
    pub const ETH_TOKEN_ADDRESS: felt252 = 0x049d36570d4e46f48e99674bd3fcc84644ddd6b96f7c741b1562b82f9e004dc7;

    pub const PRAGMA_ORACLE_VRF_ADDRESS: felt252 = 0x60c69136b39319547a4df303b6b3a26fab8b2d78de90b6bd215ce82e9cb515c;

    // Sepolia : 0x60c69136b39319547a4df303b6b3a26fab8b2d78de90b6bd215ce82e9cb515c
    // Mainnet : 0x4fb09ce7113bbdf568f225bc757a29cb2b72959c21ca63a7d59bdb9026da661

    
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
        tickets: Map::<(u32, Ticket), ContractAddress>,
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

        fn buy_ticket(ref self: ContractState, user_ticket: Ticket){
            // Check that the user ticket is valid
            assert(user_ticket.verify(), Errors::INVALID_TICKET);

            // Check the current contest is still ongoing
            let contest_id: u32 = self.last_contest_id.read();
            let current_contest: Contest = self.contests.read(contest_id);
            assert(get_block_timestamp() < current_contest.end_time, Errors::NOT_ONGOING_CONTEST);

            // Check the price match
            let ticket_price = current_contest.price;

            // Check the ticket is still available
            // FIXME: change variable name
            let ticket = self.tickets.read((contest_id, user_ticket));
            assert(ticket == contract_address_const::<0>(), Errors::TICKET_ALREADY_BOUGHT);

            // Buy the ticket
            let erc20_dispatcher = IERC20Dispatcher { 
                contract_address: contract_address_const::<STARKNET_TOKEN_ADDRESS>() 
            };
            let success = erc20_dispatcher.transfer_from(get_caller_address(), get_contract_address(), ticket_price);
            assert(success, Errors::NOT_ENOUGH_FUNDS);

            // Assign the ticket to the user
            self.tickets.write((contest_id, user_ticket), get_caller_address());
        }


        // pub const PUBLISH_DELAY: u64 = 1; // return the random value asap
        // pub const NUM_OF_WORDS: u64 = 1; // one random value is sufficient
        // pub const CALLBACK_FEE_LIMIT: u128 = 100_000_000_000_000; // 0.0001 ETH
        // pub const MAX_CALLBACK_FEE_DEPOSIT: u256 =
        //     500_000_000_000_000; // CALLBACK_FEE_LIMIT * 5; needs to cover the Premium fee
    

        fn end_contest(ref self: ContractState){

            // FIXME:
            let seed: u64 = 100;
            let callback_fee_limit = 100;
            let publish_delay: u64 = 10;
            let num_words: u64 = 5;
            let calldata: Array<felt252> = ArrayTrait::new();


            // Check that the contest is not already finished
            let lastToken: u32 = self.last_contest_id.read();
            let last_contest: Contest = self.contests.read(lastToken);
            assert(last_contest.end_time != 0, Errors::ALREADY_FINISHED_CONTEST);

            // Check that the contest is finished
            assert(last_contest.end_time < get_block_timestamp(), Errors::CONTEST_IS_RUNNING);

            // Generate a random number for the ticket
            let randomness_contract_address = contract_address_const::<PRAGMA_ORACLE_VRF_ADDRESS>();
            let randomness_dispatcher = IRandomnessDispatcher { contract_address: randomness_contract_address };

            // We need to pay the Pragma contract with some ETH to cover the fees
            let eth_dispatcher = IERC20Dispatcher { contract_address: contract_address_const::<ETH_TOKEN_ADDRESS>() };
            eth_dispatcher.approve(
                randomness_contract_address,
                (callback_fee_limit + callback_fee_limit / 5).into(),
            );

            // Request the randomness
            randomness_dispatcher.request_random(seed, get_contract_address(), callback_fee_limit, publish_delay, num_words, calldata);

        }

        fn randomness_callback(
            ref self: ContractState,
            requestor_address: ContractAddress,
            request_id: u64,
            random_words: Span<felt252>,
            calldata: Array<felt252>
        ) {
            // Check that the contest is not already finished
            // FIXME: change variable name 
            let lastToken: u32 = self.last_contest_id.read();
            let last_contest: Contest = self.contests.read(lastToken);
            assert(last_contest.end_time != 0, Errors::ALREADY_FINISHED_CONTEST);

            // Check that the contest is finished
            assert(last_contest.end_time < get_block_timestamp(), Errors::CONTEST_IS_RUNNING);

            
            // Have to make sure that the caller is the Pragma Randomness Oracle contract
            let caller_address = get_caller_address();
            assert(
                caller_address == contract_address_const::<PRAGMA_ORACLE_VRF_ADDRESS>(),
                'caller not randomness contract'
            );
            
            // Requestor address should be the contract one
            let contract_address = get_contract_address();
            assert(requestor_address == contract_address, 'requestor is not self');

            // Given the random number generate a valid ticket
            let chosen_ticket = random_ticket(*random_words.at(0));

            // Check if this ticket is own by someone
            let winner_address = self.tickets.read((lastToken, chosen_ticket));

            // Check if we have a winner!
            if winner_address != contract_address_const::<0>() {
                // TODO:
                let erc20_dispatcher = IERC20Dispatcher { 
                    contract_address: contract_address_const::<STARKNET_TOKEN_ADDRESS>() 
                };
                let contract_balance = erc20_dispatcher.balance_of(get_contract_address());
                let success = erc20_dispatcher.transfer(winner_address, contract_balance);
                assert(success, Errors::TRANSFER_ERROR);
            }

            // Finished the contest
            self.last_contest_id.write(self.last_contest_id.read() + 1);
        }

    }
}
