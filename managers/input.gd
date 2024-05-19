extends Node


const MOVE_UP = "move_up"
const MOVE_DOWN = "move_down"
const MOVE_RIGHT = "move_right"
const MOVE_LEFT = "move_left"
const INTERACT = "interact"

const MOVEMENT_ACTIONS = [
	MOVE_UP,
	MOVE_DOWN,
	MOVE_RIGHT,
	MOVE_LEFT,
]

signal movement_action_pressed(movement_action: String)
signal movement_action_released(movement_action: String)

signal advance_dialogue


func _input(input_event: InputEvent):
	if StateManager.should_player_be_able_to_move:
		_process_player_input_event(input_event)
	else:
		_process_ui_input_event(input_event)


func _process_player_input_event(input_event: InputEvent):
	for movement_action in MOVEMENT_ACTIONS:
		if input_event.is_action_pressed(movement_action):
			movement_action_pressed.emit(movement_action)
		if input_event.is_action_released(movement_action):
			movement_action_released.emit(movement_action)
	
	if input_event.is_action_pressed(INTERACT):
		StateManager.player.interaction_detector.activate_closest_interaction()


func _process_ui_input_event(input_event: InputEvent):
	if input_event.is_action_pressed(INTERACT):
		self.advance_dialogue.emit()
