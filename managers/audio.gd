extends Node

signal play_sound_effect(sound_effect_name: String)

func play_click_sound_effect():
	self.play_sound_effect.emit("click")
