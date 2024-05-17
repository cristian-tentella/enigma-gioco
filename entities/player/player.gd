extends CharacterBody2D


@onready var animated_sprite = $AnimatedSprite2D
@onready var interaction_detector = $InteractionDetector

const pause_menu_scene = preload("res://ui/pause_menu/pause_menu.tscn")

@export_category("Settings")
@export_group("Movement constants")
@export var MAX_SPEED: float = 128
@export var ACCELERATION: float = 8
@export var FRICTION: float = 16

var input = Vector2.ZERO

const MOVEMENT_ACTIONS = ["move_left", "move_right", "move_up", "move_down"]
var movement_actions_queue: Array[String]


func _physics_process(delta: float):
	update_velocity(delta)
	move_and_slide()


func _unhandled_input(event: InputEvent):
	update_movement_actions_list(event)
	handle_remaining_actions(event)
	update_input_vector()
	update_animated_sprite()
	update_interaction_detector_position()


func update_velocity(delta: float):
	if self.input == Vector2.ZERO:
		self.velocity = self.velocity.lerp(Vector2.ZERO, self.FRICTION * delta)
	else:
		self.velocity = self.velocity.lerp(
			self.MAX_SPEED * self.input.normalized(),
			self.ACCELERATION * delta
		)


func update_movement_actions_list(event: InputEvent):
	for movement_action in self.MOVEMENT_ACTIONS:
		if event.is_action_pressed(movement_action):
			self.movement_actions_queue.append(movement_action)
		if event.is_action_released(movement_action):
			self.movement_actions_queue.erase(movement_action)
	if not State.should_player_be_able_to_move():
		self.movement_actions_queue.clear()


func update_input_vector():
	var new_input = Vector2.ZERO

	for movement_action in self.movement_actions_queue:
		new_input += get_vector_from_movement_action(movement_action)

	self.input = new_input


func handle_remaining_actions(event: InputEvent):
	# TODO: find a better place for this
	if event.is_action_pressed("interact"):
		self.interaction_detector.activate_closest_interaction()


func update_animated_sprite():
	var current_animation_name: String = self.animated_sprite.animation
	
	var next_animation_name = current_animation_name
	if not self.movement_actions_queue.is_empty():
		next_animation_name = latest_movement_action()
	else:
		next_animation_name = current_animation_name.replace("move", "idle")

	self.animated_sprite.play(next_animation_name)


func update_interaction_detector_position():
	const offset_multiplier = 24
	self.interaction_detector.position = input * offset_multiplier


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


func latest_movement_action() -> String:
	return self.movement_actions_queue.back()
