extends CharacterBody2D


@export_category("Settings")
@export_group("Movement constants")
@export var max_speed: float = 128
@export var acceleration: float = 8
@export var friction: float = 16


func get_input() -> Vector2:
	return Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	)


func calculate_new_velocity(
	current_velocity: Vector2,
	input: Vector2,
	delta: float
) -> Vector2:
	var new_velocity: Vector2

	if input == Vector2.ZERO:
		new_velocity = current_velocity.lerp(Vector2.ZERO, friction * delta)
	else:
		new_velocity = current_velocity.lerp(
			max_speed * input.normalized(),
			acceleration * delta
		)

	return new_velocity


func _physics_process(delta: float):
	velocity = calculate_new_velocity(velocity, get_input(), delta)
	move_and_slide()
