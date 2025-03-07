extends Node

# Reference to the mob scene to be instantiated.
@export var mob_scene: PackedScene

# Player's score in the current game.
var score = 0

func _ready() -> void:
	# Connect signals for game flow control.
	$Player.hit.connect(game_over)
	$HUD.start_game.connect(new_game)

func game_over() -> void:
	# End the current game session.
	$HUD.show_game_over()
	$ScoreTimer.stop()
	$MobTimer.stop()

	# Stop music and play death sound.
	$Music.stop()
	$DeathSound.play()

func new_game() -> void:
	# Reset game state for a new session.
	score = 0
	
	# Remove any remaining mobs from the previous game.
	get_tree().call_group("mobs", "queue_free")

	# Update UI and prepare player.
	$HUD.update_score(score)
	$HUD.show_message("Get Ready!")
	$Player.start($StartPosition.position)
	
	# Start the countdown before spawning mobs.
	$StartTimer.start()

	# Start background music.
	$Music.play()

func _on_mob_timer_timeout() -> void:
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()

	# Choose a random location on Path2D for mob spawning.
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()

	# Position the mob at the spawn point.
	mob.position = mob_spawn_location.position

	# Calculate mob direction perpendicular to the path.
	# This ensures mobs move toward the player area.
	var direction = mob_spawn_location.rotation + PI / 2

	# Add randomness to direction for unpredictable movement.
	direction += randf_range(- PI / 4, PI / 4)
	mob.rotation = direction

	# Set random velocity within a specific range for varied difficulty.
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# Add the mob to the scene tree.
	add_child(mob)


func _on_score_timer_timeout() -> void:
	# Increment score every second and update the HUD.
	score += 1
	$HUD.update_score(score)

func _on_start_timer_timeout() -> void:
	# Start spawning mobs and counting score after initial delay.
	$MobTimer.start()
	$ScoreTimer.start()
