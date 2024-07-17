extends Control


@onready var muted_button = $Muted
@onready var unmuted_button = $Unmuted

@onready var master_bus_index = AudioServer.get_bus_index("Master")


func _ready():
	_load_muted_from_state_manager()
	_update_icon()


func _toggle_mute():
	AudioServer.set_bus_mute(master_bus_index, not _is_muted())
	_save_muted_to_state_manager()
	_update_icon()


func _is_muted():
	return AudioServer.is_bus_mute(master_bus_index)


func _on_pressed():
	_toggle_mute()


func _update_icon():
	if _is_muted():
		muted_button.show()
		unmuted_button.hide()
	else:
		unmuted_button.show()
		muted_button.hide()


func _save_muted_to_state_manager():
	StateManager.muted = _is_muted()


func _load_muted_from_state_manager():
	AudioServer.set_bus_mute(master_bus_index, StateManager.muted)
