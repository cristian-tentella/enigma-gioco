extends CharacterBody2D

# TODO:	change the position of InteractionDetector based on the direction in
#		which the player is facing


@onready var animated_sprite = $AnimatedSprite2D
@onready var interaction_detector = $InteractionDetector

@export_category("Settings")
@export_group("Movement constants")
@export var max_speed: float = 128
@export var acceleration: float = 8
@export var friction: float = 16

var input = Vector2.ZERO

const MOVEMENT_ACTIONS = ["move_left", "move_right", "move_up", "move_down"]
var movement_actions_list: Array[String]


func get_vector_from_movement_action(movement_action: String):
	match movement_action:
		"move_left":
			return Vector2.LEFT
		"move_right":
			return Vector2.RIGHT
		"move_up":
			return Vector2.UP
		"move_down":
			return Vector2.DOWN


func calculate_input_vector(movement_actions: Array[String]) -> Vector2:
	var new_input = Vector2.ZERO

	for movement_action in movement_actions:
		new_input += get_vector_from_movement_action(movement_action)

	return new_input


func should_halt():
	return DialogueSystemSingleton.dialogue_box_is_inside_tree 


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
	var current_animation_name: String = animated_sprite.animation
	
	var next_animation_name = current_animation_name
	if not movement_actions_list.is_empty():
		next_animation_name = movement_actions_list.back()
	else:
		next_animation_name = current_animation_name.replace("move", "idle")

	animated_sprite.play(next_animation_name)


func _physics_process(delta: float):
	velocity = calculate_new_velocity(velocity, input, delta)
	move_and_slide()


func _unhandled_input(event: InputEvent):
	for movement_action in MOVEMENT_ACTIONS:
		if event.is_action_pressed(movement_action):
			movement_actions_list.append(movement_action)
		if event.is_action_released(movement_action):
			movement_actions_list.erase(movement_action)

	if should_halt():
		movement_actions_list.clear()

	input = calculate_input_vector(movement_actions_list)

	# TODO: find a better place for this
	if event.is_action_pressed("interact"):
		interaction_detector.activate_closest_interaction()

	update_animated_sprite()
