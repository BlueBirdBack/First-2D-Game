extends Node

# Reference to the mob scene to be instantiated.
@export var mob_scene: PackedScene

# Player's score in the current game.
var score = 0

# Start timer duration (to replace the StartTimer node)
@export var start_delay_time: float = 2.0

# Node references using @onready
@onready var player = $Player
@onready var hud = $HUD
@onready var music = $Music
@onready var death_sound = $DeathSound
@onready var score_timer = $ScoreTimer
@onready var mob_timer = $MobTimer
@onready var start_position = $StartPosition
@onready var mob_path = $MobPath
@onready var mob_spawn_location = $MobPath/MobSpawnLocation

func _ready() -> void:
	# Connect `timeout` signals for the 2 timers
	# - MobTimer: Spawns new enemies when timeout
	# - ScoreTimer: Increments player score when timeout
	mob_timer.timeout.connect(_on_mob_timer_timeout)
	score_timer.timeout.connect(_on_score_timer_timeout)

	# Connect game flow control signals
	SignalBus.player_hit.connect(game_over)
	SignalBus.game_started.connect(new_game)

func game_over() -> void:
	# End the current game session.
	hud.show_game_over()
	score_timer.stop()
	mob_timer.stop()

	# Stop music and play death sound.
	music.stop()
	death_sound.play()

func new_game() -> void:
	# Reset game state for a new session.
	score = 0
	
	# Remove any remaining mobs from the previous game.
	get_tree().call_group("mobs", "queue_free")

	# Update UI and prepare player.
	hud.update_score(score)
	hud.show_message("Get Ready!")
	player.start(start_position.position)
	
	# Use create_timer instead of StartTimer node
	var start_timer = get_tree().create_timer(start_delay_time)
	start_timer.timeout.connect(_on_start_timer_timeout.bind(), CONNECT_ONE_SHOT)

	# Start background music.
	music.play()

func _on_mob_timer_timeout() -> void:
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()

	# Choose a random location on Path2D for mob spawning.
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
	hud.update_score(score)

func _on_start_timer_timeout() -> void:
	# Start spawning mobs and counting score after initial delay.
	mob_timer.start()
	score_timer.start()
