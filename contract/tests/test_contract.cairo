use starknet::ContractAddress;

use starknet::{contract_address_const};

use snforge_std::{declare, ContractClassTrait, DeclareResultTrait};

use contract::ILotteryStarknetSafeDispatcher;
use contract::ILotteryStarknetSafeDispatcherTrait;
// use contract::ILotteryStarknetDispatcher;
// use contract::ILotteryStarknetDispatcherTrait;

fn deploy_contract(name: ByteArray, owner: ContractAddress) -> ContractAddress {
    let contract = declare(name).unwrap().contract_class();
    let mut params = ArrayTrait::new();
    params.append(owner.into());

    let (contract_address, _) = contract.deploy(@params).unwrap();
    contract_address
}

#[test]
fn test_deploy_and_create_contest() {
    let owner = contract_address_const::<'owner'>();
    let contract_address = deploy_contract("LotteryStarknet", owner);

    let dispatcher = ILotteryStarknetSafeDispatcher { contract_address };
    let _ = dispatcher.create_new_contest(1738368000);
}

// #[test]
// #[feature("safe_dispatcher")]
// fn test_cannot_increase_balance_with_zero_value() {
//     let contract_address = deploy_contract("HelloStarknet");

//     let safe_dispatcher = IHelloStarknetSafeDispatcher { contract_address };

//     let balance_before = safe_dispatcher.get_balance().unwrap();
//     assert(balance_before == 0, 'Invalid balance');

//     match safe_dispatcher.increase_balance(0) {
//         Result::Ok(_) => core::panic_with_felt252('Should have panicked'),
//         Result::Err(panic_data) => {
//             assert(*panic_data.at(0) == 'Amount cannot be 0', *panic_data.at(0));
//         }
//     };
// }
