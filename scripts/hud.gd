extends CanvasLayer

# Reference to UI nodes
@onready var fps_label: Label = $FPS
@onready var message: Label = $Message
@onready var score_label: Label = $ScoreLabel
@onready var start_button: Button = $StartButton

# Time accumulator for FPS updates to avoid updating every frame.
var fps_update_timer: float = 0.0

func _ready() -> void:
	# Connect the start button to its handler using the newer syntax.
	start_button.pressed.connect(_on_start_button_pressed)

	# Connect the score_updated signal to its handler.
	SignalBus.score_updated.connect(_on_score_updated)

	# Connect the game_over signal to its handler.
	SignalBus.game_over.connect(_on_game_over)

	# Initialize FPS display if the label exists.
	if fps_label:
		fps_label.show()

func _process(delta: float) -> void:
	# Update FPS counter approximately once per second for efficiency.
	fps_update_timer += delta
	if fps_update_timer >= 1.0:
		fps_update_timer = 0.0
		if fps_label:
			fps_label.text = "FPS: %d" % Engine.get_frames_per_second()

## Displays a message on the HUD with optional auto-hiding functionality.
## If `auto_hide` is true, the message will disappear after 3 seconds.
func _show_message(text: String, auto_hide: bool = true) -> void:
	message.text = text
	message.show()
	
	if auto_hide:
		# Wait 3 seconds before hiding the message.
		await get_tree().create_timer(3.0).timeout
		message.hide()

## Handles the game over sequence by showing messages and resetting UI elements.
func _on_game_over() -> void:
	await _show_message("Game Over")
	
	# Reset score display to zero.
	score_label.text = "0"
	
	# Show the main message and make the start button visible again.
	_show_message("Dodge the Creeps!", false)
	start_button.show()

## Updates the score display with the current score.
func _on_score_updated(score: int) -> void:
	score_label.text = str(score)

## Starts a new game when the player presses the start button.
func _on_start_button_pressed() -> void:
	start_button.hide()
	SignalBus.game_started.emit()
	_show_message("Get Ready!")