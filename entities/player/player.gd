extends CharacterBody2D


@onready var animated_sprite = $AnimatedSprite2D

@export_category("Settings")
@export_group("Movement constants")
@export var max_speed: float = 128
@export var acceleration: float = 8
@export var friction: float = 16

const MOVEMENT_ACTIONS = ["move_left", "move_right", "move_up", "move_down"]
var movement_actions_list: Array[String]


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


func update_animated_sprite():
	var current_animation_name = animated_sprite.animation
	
	var next_animation_name = current_animation_name
	if not movement_actions_list.is_empty():
		next_animation_name = movement_actions_list.back()

	animated_sprite.play(next_animation_name)


func _physics_process(delta: float):
	velocity = calculate_new_velocity(velocity, get_input(), delta)
	update_animated_sprite()
	move_and_slide()


func _unhandled_input(event: InputEvent):
	for movement_action in MOVEMENT_ACTIONS:
		if event.is_action_pressed(movement_action):
			movement_actions_list.append(movement_action)
		if event.is_action_released(movement_action):
			movement_actions_list.erase(movement_action)
