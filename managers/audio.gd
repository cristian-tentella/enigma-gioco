extends Node

signal play_sound_effect(sound_effect_name: String)
signal play_sound_track(sound_track_name: String)

# Questa funzione viene chiamata nella funzione _spawn_ui_element di
# UIManager (managers/ui.gd) in modo da associare ad ogni nuovo elemento di UI
# aggiunto allo schermo il "trigger" sonoro corrispondente
func setup_sound_triggers():
	make_buttons_play_click_sound_effect()

func make_buttons_play_click_sound_effect():
	# Ogni Button che necessita della riproduzione del suono "click" quando
	# viene premuto deve essere aggiunto al gruppo "Buttons"
	var buttons: Array = get_tree().get_nodes_in_group("Buttons")
	
	for button in buttons:
		if not button.is_connected("pressed", _on_button_pressed):
			button.pressed.connect(_on_button_pressed)

func _on_button_pressed():
	self.play_click_sound_effect()

func play_click_sound_effect():
	self.play_sound_effect.emit("click")

func play_step_sound_effect():
	self.play_sound_effect.emit("step")

func play_item_pickup_sound_effect():
	self.play_sound_effect.emit("item_pickup")

func play_menu_sound_effect():
	self.play_sound_effect.emit("menu")

func play_success_sound_effect():
	self.play_sound_effect.emit("success")

func play_failure_sound_effect():
	self.play_sound_effect.emit("failure")

func play_lullaby_sound_track():
	self.play_sound_track.emit("Lullaby")
