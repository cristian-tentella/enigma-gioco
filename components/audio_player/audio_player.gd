class_name AudioPlayer
extends Node

var audio_stream_player_for_sound_track: AudioStreamPlayer

func _ready():
	AudioManager.play_sound_effect.connect(_on_audio_manager_play_sound_effect)
	AudioManager.play_sound_track.connect(_on_audio_manager_play_sound_track)

func _on_audio_manager_play_sound_effect(sound_effect_name: String):
	var audio_stream_player = _convert_sound_effect_name_to_audio_stream_player(sound_effect_name)

	# audio_stream_player è null quando _convert_sound_effect_name_to_audio_stream_player
	# è stata chiamata con un sound_effect_name che non corrisponde a nessun
	# effetto sonoro tra quelli a disposizione
	if audio_stream_player == null:
		return

	audio_stream_player.play()

func _on_audio_manager_play_sound_track(sound_track_name: String):
	if !audio_stream_player_for_sound_track.is_playing():
		audio_stream_player_for_sound_track = _convert_sound_effect_name_to_audio_stream_player(sound_track_name)
		if audio_stream_player_for_sound_track == null:
			return

		audio_stream_player_for_sound_track.play()
	else:
		push_error("Non puoi suonare due sound track in contemporanea")
	
	
func _convert_sound_effect_name_to_audio_stream_player(sound_effect_name: String) -> AudioStreamPlayer:
	var audio_stream_player_for_sound_effects: AudioStreamPlayer

	match sound_effect_name:
		"click":
			audio_stream_player_for_sound_effects = $SoundEffects/Click
		_:
			push_error("Non esiste alcun effetto sonoro chiamato '{0}'".format([sound_effect_name]))
			return null

	return audio_stream_player_for_sound_effects


func _convert_sound_track_name_to_audio_stream_player(sound_track_name: String) -> AudioStreamPlayer:
	match sound_track_name:
		"Lullaby":
			audio_stream_player_for_sound_track = $SoundTracks/Lullaby
		_:
			push_error("Non esiste alcun effetto sonoro chiamato '{0}'".format([sound_track_name]))
			return null

	return audio_stream_player_for_sound_track
	
