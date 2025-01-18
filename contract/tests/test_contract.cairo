use starknet::ContractAddress;

use starknet::{contract_address_const};

use snforge_std::{declare, ContractClassTrait, DeclareResultTrait};

use contract::Ticket;
use contract::random_ticket;

// use contract::ILotteryStarknetSafeDispatcher;
// use contract::ILotteryStarknetSafeDispatcherTrait;
use contract::ILotteryStarknetDispatcher;
use contract::ILotteryStarknetDispatcherTrait;

fn deploy_contract(name: ByteArray) -> (ILotteryStarknetDispatcher, ContractAddress) {
    let contract = declare(name).unwrap().contract_class();

    let owner: ContractAddress = contract_address_const::<'owner'>();
    let constructor_calldata = array![owner.into()];

    let (contract_address, _) = contract.deploy(@constructor_calldata).unwrap();
    
    let dispatcher = ILotteryStarknetDispatcher { contract_address };

    (dispatcher, contract_address)
}

#[test]
fn test_deploy_and_create_contest() {
    let (dispatcher, _contract_address) = deploy_contract("LotteryStarknet");

    let _ = dispatcher.create_new_contest(1738368000);
    // let ticket = Ticket {
    //     num1: 1,
    //     num2: 2,
    //     num3: 12,
    //     num4: 16,
    //     num5: 18
    // };

    // let _ = dispatcher.buy_ticket(ticket);
}


#[test]
fn test_generate_random_ticket() {
    let seed = 18;

    let random_ticket: Ticket = random_ticket(seed);
    let expected_ticket = Ticket {
        num1: 4,
        num2: 13,
        num3: 20,
        num4: 39,
        num5: 43
    };

    // println!("{} - {} - {} - {} - {}", random_ticket.num1, random_ticket.num2, random_ticket.num3, random_ticket.num4, random_ticket.num5);
    assert(random_ticket == expected_ticket, 'Not expected ticket');
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
