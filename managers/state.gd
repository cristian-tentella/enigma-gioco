extends Node


var player: Player
var house: House

var is_a_dialogue_in_progress = false
var should_player_be_able_to_move = true

signal player_can_move(player_can_move: bool)


func _ready():
	UIManager.lock.connect(
		func():
			player_can_move.emit(false)
			self.should_player_be_able_to_move = false
	)
	UIManager.unlock.connect(
		func():
			player_can_move.emit(true)
			self.should_player_be_able_to_move = true
	)

	DialogueManager.has_started_displaying.connect(
		func():
			self.is_a_dialogue_in_progress = true
	)
	DialogueManager.has_finished_displaying.connect(
		func():
			self.is_a_dialogue_in_progress = false
	)
