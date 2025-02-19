module iceriver

import x.json2
import net.http

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

pub fn fetch_data(url string) !IceRiverData {
	url2 := url.trim_right("/")

	mut req := map[string]string{}
	req["post"] = "4"

	res := http.post_form(url2+"/user/userpanel", req) or {
		return err
	}

	if res.status_code >= 300 {
		return error("ASIC returned illegal status code: ${res.status_code}")
	}

	r := json2.raw_decode(res.body) or {
		return err
	}.as_map()

	// Origin data object
	mut obj := IceRiverData{}


	// Check is Error
	if e := r["error"]{
		if e.int() != 0 && r["message"] or {json2.Any("")}.str() != "" {
			return error("Error while send request: (${r["error"] or {0}}) ${r["message"] or {"No message."}}")
		}
	}


	// Eject Data Fields
	data := r["data"] or {
		return error("No data field found!")
	}.as_map()


	// Eject Fan data
	fans := data["fans"] or {json2.Any([]json2.Any{})}.arr()
	for fan in fans {
		obj.fan_speeds << fan.int()
	}


	// Eject hashrate history
	pows := data["pows"] or {json2.Any{}}.as_map()


	// Eject boards
	boards := data["boards"] or {json2.Any([]json2.Any{})}.arr()
	for board in boards {
		board_as_map := board.as_map()

		mut board_obj := IceRiverBoardData{}

		// number
		board_obj.num = board_as_map["no"] or {json2.Any(0)}.int()

		// freq
		board_obj.freq = board_as_map["freq"] or {json2.Any(0)}.int()

		// in temp
		board_obj.in_temp = board_as_map["intmp"] or {json2.Any(0)}.int()

		// out temp
		board_obj.out_temp = board_as_map["outtmp"] or {json2.Any(0)}.int()

		// state of board
		board_obj.state = board_as_map["state"] or {json2.Any(false)}.bool()


		// Eject hashrate history for board
		if history := pows["board"+board_obj.num.str()] {
			hs := history.arr()
			for h in hs {
				board_obj.hashrate_history << h.int()
			}
		}


		// Put board to boards
		obj.boards << board_obj
	}


	// Eject hashrate history unit
	powsx := data["pows_x"] or {json2.Any{}}.arr()
	for powx in powsx {
		obj.hashrate_history_units << powx.str()
	}


	// Eject hashrate unit
	obj.hashrate_unit = data["unit"] or {json2.Any("")}.str()


	// Eject avg hashrate
	obj.average_hashrate = data["avgpow"] or {json2.Any("")}.str()


	// Eject rt hashrate
	obj.realtime_hashrate = data["rtpow"] or {json2.Any("")}.str()


	// Eject uptime
	runtime := data["runtime"] or {json2.Any("")}.str()
	obj.uptime_str = runtime
	obj.uptime_in_seconds = parse_time_to_seconds(runtime)


	// Eject pool data
	pools := data["pools"] or {json2.Any{}}.arr()
	for pool in pools {
		pool_as_map := pool.as_map()

		mut pool_obj := IceRiverPoolData{}

		pool_obj.accepted_shares = pool_as_map["accepted"] or {json2.Any{}}.int()
		pool_obj.rejected_shares = pool_as_map["rejected"] or {json2.Any{}}.int()

		pool_obj.state = pool_as_map["state"] or {json2.Any{}}.int()
		pool_obj.priority = pool_as_map["priority"] or {json2.Any{}}.int()
		pool_obj.is_connect = pool_as_map["connect"] or {json2.Any{}}.bool()

		pool_obj.diff = pool_as_map["diff"] or {json2.Any{}}.str()
		pool_obj.addr = pool_as_map["addr"] or {json2.Any{}}.str()

		pool_obj.wallet = pool_as_map["user"] or {json2.Any{}}.str()
		pool_obj.wallet_password = pool_as_map["pass"] or {json2.Any{}}.str()


		obj.pools << pool_obj
	}


	return obj
}
