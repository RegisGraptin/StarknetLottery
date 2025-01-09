/// Interface representing `HelloContract`.
/// This interface allows modification and retrieval of the contract balance.
#[starknet::interface]
pub trait IHelloStarknet<TContractState> {
    /// Increase contract balance.
    fn increase_balance(ref self: TContractState, amount: felt252);
    /// Retrieve contract balance.
    fn get_balance(self: @TContractState) -> felt252;
}

/// Simple contract for managing balance.
#[starknet::contract]
mod HelloStarknet {
    use starknet::ContractAddress;
    
    use core::starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};

    use core::starknet::get_block_timestamp;

    use starknet::storage::Map;

    struct Contest {
        id: felt252,
        start_time: u64,
        end_time: u64,
        price: felt252,
    }

    #[storage]
    struct Storage {
        last_contest_id: u32,
        contests: Map<u32, Contest>,
        tickets: Map<(u32, u32), ContractAddress>,
    }

    #[abi(embed_v0)]
    impl HelloStarknetImpl of super::IHelloStarknet<ContractState> {
        fn increase_balance(ref self: ContractState, amount: felt252) {
            assert(amount != 0, 'Amount cannot be 0');
            // self.balance.write(self.balance.read() + amount);
        }

        fn get_balance(self: @ContractState) -> felt252 {
            // self.balance.read()
            0
        }

        // fn buy_ticket(ref self: ContractState)

    }
}
