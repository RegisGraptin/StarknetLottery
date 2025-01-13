# On chain lottery on Starknet
> Built for 'Starknet Winter Hackathon'
> https://app.buidlbox.io/starknet/starknet-winter


> Design a lottery system where entry fees are pooled and prizes are distributed onchain.


SethLottery
Inspiration: Set (Seth), the god of chaos and disorder, embodies unpredictability—perfect for a game of chance like a lottery. "SetSpin" could highlight the chaotic nature of chance and fortune, where anything can happen.
Design Ideas: Use darker tones, reds, and blacks to symbolize Set’s association with chaos and turmoil. The logo could feature a spinning wheel or an abstract depiction of chaos, giving it an edgy, modern vibe.


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
