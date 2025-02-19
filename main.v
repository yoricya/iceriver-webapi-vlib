module main

import iceriver
import os

fn main() {
	// dat["user"] = "admin"
	// dat["pwd"] = "12345678"
	// res := http.post_form("http://192.168.0.121/user/loginpost", dat) or {
	// 	panic(err)
	// }

	ip := os.input("Input IP of ASIC: ")

	if d := iceriver.fetch_data("http://${ip}/") {
		println(d)
	} else {
		println(err)
	}
}
