extends RigidBody2D

func _ready():
	# Pick a random animation from the available mob types.
	# This creates visual variety among spawned enemies.
	var mob_types = Array($AnimatedSprite2D.sprite_frames.get_animation_names())
	$AnimatedSprite2D.animation = mob_types.pick_random()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	# Remove the mob when it exits the screen to prevent memory leaks.
	queue_free()
