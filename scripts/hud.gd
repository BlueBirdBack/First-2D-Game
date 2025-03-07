extends CanvasLayer

signal start_game

@onready var fps_label: Label = $FPS

var fps_update_timer: float = 0.0

func _ready() -> void:
	$StartButton.connect("pressed", _on_start_button_pressed)
	$MessageTimer.connect("timeout", _on_message_timer_timeout)
	if fps_label:
		fps_label.show()

func _process(delta: float) -> void:
	fps_update_timer += delta
	if fps_update_timer >= 1.0:
		fps_update_timer = 0.0
		if fps_label:
			fps_label.text = "FPS: " + str(Engine.get_frames_per_second())

func show_message(text: String) -> void:
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_game_over() -> void:
	show_message("Game Over")
	await $MessageTimer.timeout

	$Message.text = "Dodge the Creeps!"
	$Message.show()

	await get_tree().create_timer(1.0).timeout
	$StartButton.show()

func update_score(score: int) -> void:
	$ScoreLabel.text = str(score)

func _on_start_button_pressed() -> void:
	$StartButton.hide()
	start_game.emit()

func _on_message_timer_timeout() -> void:
	$Message.hide()
