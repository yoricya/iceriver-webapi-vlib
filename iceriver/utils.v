module iceriver

fn parse_time_to_seconds(time_str string) int {
	parts := time_str.split(':')


	mut days := 0
	mut hours := 0
	mut minutes := 0
	mut seconds := 0


	if parts.len > 0 {
		days = parts[0] or {"0"}.int()
		if days > 30 {
			days = 0
		}
	}

	if parts.len > 1 {
		hours = parts[1] or {"0"}.int()
	}

	if parts.len > 2 {
		minutes = parts[2] or {"0"}.int()
	}

	if parts.len > 3 {
		seconds = parts[3] or {"0"}.int()
	}


	total_seconds := days * 24 * 60 * 60 +
	hours * 60 * 60 +
	minutes * 60 +
	seconds


	return total_seconds
}
