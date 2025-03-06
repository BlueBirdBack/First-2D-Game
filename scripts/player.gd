extends Area2D

signal hit

@export var speed: int = 200

var game_window_size: Vector2

func _ready() -> void:
	game_window_size = get_viewport_rect().size
	print(game_window_size) # (600.0, 900.0)
	body_entered.connect(_on_body_entered)
	hide()

func _process(delta):
	var fps = Engine.get_frames_per_second()
	# print("FPS: ", fps)
	# $Label.text = "FPS: " + str(int(fps))

	var velocity = Vector2.ZERO

	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()

	position += velocity * delta
	position = position.clamp(Vector2.ZERO, game_window_size)

	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = velocity.y > 0

	# if velocity.x < 0:
	# 	$AnimatedSprite2D.flip_h = true
	# else:
	# 	$AnimatedSprite2D.flip_h = false

func _on_body_entered(body: Node2D) -> void:
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)

func start(pos: Vector2) -> void:
	position = pos
	show()
	$CollisionShape2D.disabled = false
