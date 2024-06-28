extends Node

signal play_sound_effect(sound_effect_name: String)
signal play_sound_track(sound_track_name: String)

func play_click_sound_effect():
	self.play_sound_effect.emit("click")


func play_lullaby_sound_track():
	self.play_sound_track.emit("Lullaby")
