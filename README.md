# Simple Api for ASIC's IceRiver written in V

* Tested in __KS0__ and __KS0 Pro__ with `Incidr-Exo160_miner/1597994_ks0bg` and `0627_v1_ks0miner/0627_ks0bg` firmware.

### How to install

```bash
 v install "https://github.com/yoricya/iceriver-webapi-vlib"
```

### How to use

_Example:_
```v
module main

// Import api lib
import iceriver_webapi.iceriver

fn main() {
    // Set ASIC web interface url
    asic_url := "http://192.168.0.5/"
  
    // Fetch ASIC data
    result := iceriver.fetch_data(asic_url) or {
      panic(err) // Panic if error while fetching
    }

    // Println result to console
    println(result) 
}
```

_Result:_
```bash
iceriver.IceRiverData{
    fan_speeds: [0, 0, 0, 0]
    pool_rejection_percent: 0
    average_hashrate: '149G'
    realtime_hashrate: '152G'
    uptime_str: '13:19:25:15'
    uptime_in_seconds: 1193115
    hashrate_unit: 'G'
    hashrate_history_units: ['0 mins', '5 mins', '10 mins', '15 mins', '20 mins', '25 mins', '30 mins', '35 mins', '40 mins', '45 mins', '50 mins', '55 mins', '60 mins', '65 mins', '70 mins', '75 mins', '80 mins', '85 mins', '90 mins', '95 mins', '100 mins', '105 mins', '110 mins']
    boards: [iceriver.IceRiverBoardData{
        num: 1
        freq: 780
        in_temp: 24
        out_temp: 44
        state: true
        hashrate_history: [141, 143, 148, 140, 143, 147, 143, 145, 141, 144, 142, 141, 147, 149, 142, 147, 149, 151, 149, 149, 152, 143, 152]
    }]
    pools: [iceriver.IceRiverPoolData{
        num: 0
        accepted_shares: 0
        rejected_shares: 0
        state: 0
        is_connect: false
        priority: 1
        diff: '0.00 G'
        addr: 'stratum+tcp://pooladdress'
        wallet: 'abcde.asicname'
        wallet_password: '*'
    }]
}
```

### Structs of API

```v
pub struct IceRiverData {
	pub mut:
	fan_speeds []int

	pool_rejection_percent int

	average_hashrate string
	realtime_hashrate string

	uptime_str string
	uptime_in_seconds int

	hashrate_unit string
	hashrate_history_units []string

	boards []IceRiverBoardData
	pools []IceRiverPoolData
}

pub struct IceRiverBoardData {
	pub mut:
	num int
	freq int

	in_temp int
	out_temp int

	state bool

	hashrate_history []int
}

pub struct IceRiverPoolData {
	pub mut:
	num int

	accepted_shares int
	rejected_shares int

	state int
	is_connect bool
	priority int

	diff string
	addr string
	wallet string
	wallet_password string
}
```
