extends Node


func teleport_down():
	_fade_in()
	StateManager.player.set_position(Vector2(1362,730))
	await _fade_out()


func teleport_up():
	_fade_in()
	StateManager.player.set_position(Vector2(210,710))
	await _fade_out()


func _fade_in():
	StateManager.fade.show()
	StateManager.fade.fade_in()
	AudioManager.play_staircase_sound_effect()


func _fade_out():
	await get_tree().create_timer(StateManager.fade.fade_duration_in_seconds * 3).timeout
	StateManager.fade.fade_out()
	await get_tree().create_timer(StateManager.fade.fade_duration_in_seconds).timeout
