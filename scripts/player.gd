extends Area2D

# Emitted when the player collides with an enemy.
signal hit

# Movement speed in pixels per second.
@export var speed: int = 200

# Cached viewport size to constrain player movement.
var game_window_size: Vector2

# Node references using @onready
@onready var animated_sprite = $AnimatedSprite2D
@onready var collision_shape = $CollisionShape2D

func _ready() -> void:
	# Store the game window dimensions to clamp player position later.
	game_window_size = get_viewport_rect().size
	print(game_window_size) # (600.0, 900.0)
	
	# Connect the body_entered signal to handle collisions.
	body_entered.connect(_on_body_entered)
	
	# Hide the player initially until the game starts.
	hide()

func _process(delta: float) -> void:
	var velocity: Vector2 = Vector2.ZERO

	# Handle input for 4-directional movement.
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1

	if velocity.length() > 0:
		# Normalize velocity to prevent diagonal movement from being faster.
		velocity = velocity.normalized() * speed
		animated_sprite.play()
	else:
		# Stop animation when the player is not moving.
		animated_sprite.stop()

	# Update position and ensure player stays within screen boundaries.
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, game_window_size)

	# Update animation based on movement direction.
	if velocity.x != 0:
		animated_sprite.animation = "walk"
		animated_sprite.flip_v = false
		animated_sprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		animated_sprite.animation = "walk"
		animated_sprite.flip_v = velocity.y > 0

func _on_body_entered(_body: Node2D) -> void:
	# Handle collision with an enemy.
	hide()
	hit.emit()
	
	# Disable collision to prevent multiple hits.
	# Using set_deferred to avoid changing physics properties during physics processing.
	collision_shape.set_deferred("disabled", true)

func start(pos: Vector2) -> void:
	# Reset player state for a new game.
	position = pos
	show()
	collision_shape.disabled = false
