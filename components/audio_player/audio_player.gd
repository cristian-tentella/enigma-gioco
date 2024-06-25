class_name AudioPlayer
extends Node


func _ready():
	AudioManager.play_sound_effect.connect(_on_audio_manager_play_sound_effect)


func _on_audio_manager_play_sound_effect(sound_effect_name: String):
	var audio_stream_player = _convert_sound_effect_name_to_audio_stream_player(sound_effect_name)

	# audio_stream_player è null quando _convert_sound_effect_name_to_audio_stream_player
	# è stata chiamata con un sound_effect_name che non corrisponde a nessun
	# effetto sonoro tra quelli a disposizione
	if audio_stream_player == null:
		return

	audio_stream_player.play()


func _convert_sound_effect_name_to_audio_stream_player(sound_effect_name: String) -> AudioStreamPlayer:
	var audio_stream_player: AudioStreamPlayer

	match sound_effect_name:
		"click":
			audio_stream_player = $SoundEffects/Click
		_:
			push_error("Non esiste alcun effetto sonoro chiamato '{0}'".format([sound_effect_name]))
			return null

	return audio_stream_player
