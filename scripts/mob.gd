extends RigidBody2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var visible_notifier = $VisibleOnScreenNotifier2D

func _ready():
	# Pick a random animation from the available mob types.
	# This creates visual variety among spawned enemies.
	var mob_types = Array(animated_sprite.sprite_frames.get_animation_names())
	animated_sprite.animation = mob_types.pick_random()
	animated_sprite.play()

	# Connect the screen_exited signal to the handler method
	visible_notifier.screen_exited.connect(_on_visible_on_screen_notifier_2d_screen_exited)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	# Remove the mob when it exits the screen to prevent memory leaks.
	queue_free()
