extends Node

# Game flow related signals
signal game_started
signal game_over

# Player related signals
signal player_hit

# HUD related signals
signal score_updated(new_score: int)

# Debug helper method
func log_signal_emission(signal_name: String, args: Array = []) -> void:
	if OS.is_debug_build():
		var args_str = ""
		for arg in args:
			args_str += str(arg) + ", "
		if args_str.length() > 0:
			args_str = args_str.substr(0, args_str.length() - 2)
		print("Signal emitted: %s(%s)" % [signal_name, args_str])