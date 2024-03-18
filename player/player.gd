extends CharacterBody2D


@export_category("Settings")
@export_group("Movement constants")
@export var max_speed: float = 128
@export var acceleration: float = 8
@export var friction: float = 16


func _physics_process(delta: float):
	var input = Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	)

	if input == Vector2.ZERO:
		velocity = velocity.lerp(Vector2.ZERO, friction * delta)
	else:
		velocity = velocity.lerp(
			max_speed * input.normalized(),
			acceleration * delta
		)

	move_and_slide()
