# On chain lottery on Starknet
> Built for 'Starknet Winter Hackathon'
> https://app.buidlbox.io/starknet/starknet-winter


> Design a lottery system where entry fees are pooled and prizes are distributed onchain.



# Architecture 

State
- Contest [list contest c1,c2,...]
- Last contest id


Contest
- id
- start_time
- end_time
- tickets (mapping (ticket_id --> user) )
- price


ticket_id = [n1,n2,n3,n4,n5] with ni € [1;49]


-- functions

- create contest
- join contest 
- endContest

// TODO: HELPER: https://agent.starknet.id/
