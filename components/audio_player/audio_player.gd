class_name AudioPlayer
extends Node

var audio_stream_player_for_sound_track: AudioStreamPlayer
var current_audio_stream_player_for_sound_track: AudioStreamPlayer


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

	if audio_stream_player_for_sound_track != null:	
		if  audio_stream_player_for_sound_track.is_playing():
			current_audio_stream_player_for_sound_track = audio_stream_player_for_sound_track
			fade_out_audio_track(current_audio_stream_player_for_sound_track)
			convert_and_play_track(audio_stream_player_for_sound_track, sound_track_name)

	else:
		convert_and_play_track(audio_stream_player_for_sound_track, sound_track_name)
	
	print("Currently playing : " + str(audio_stream_player_for_sound_track))
	
func convert_and_play_track(audio_track: AudioStreamPlayer, sound_track_name: String):
	audio_track = _convert_sound_track_name_to_audio_stream_player(sound_track_name)
	audio_track.play()
	fade_in_audio_track(audio_track)

func fade_in_audio_track(audio_track):
	audio_track.set_volume_db(-20)
	for i in range(15):
		audio_track.set_volume_db(audio_track.get_volume_db() + 1)
		await get_tree().create_timer(0.2).timeout 

func fade_out_audio_track(audio_track):
	for i in range(15):
		audio_track.set_volume_db(audio_track.get_volume_db() - 1)
		await get_tree().create_timer(0.2).timeout 
	audio_track.stop()
	
	
func _convert_sound_effect_name_to_audio_stream_player(sound_effect_name: String) -> AudioStreamPlayer:
	var audio_stream_player_for_sound_effects: AudioStreamPlayer

	match sound_effect_name:
		"click":
			audio_stream_player_for_sound_effects = $SoundEffects/Click
		"step":
			var footsteps = [
				$SoundEffects/Footstep1,
				$SoundEffects/Footstep2,
				$SoundEffects/Footstep3,
				$SoundEffects/Footstep4
			]
			audio_stream_player_for_sound_effects = footsteps[randi() % footsteps.size()]
		"item_pickup":
			audio_stream_player_for_sound_effects = $SoundEffects/ItemPickup
		"menu":
			audio_stream_player_for_sound_effects = $SoundEffects/Menu
		"door_open":
			audio_stream_player_for_sound_effects = $SoundEffects/DoorOpen
		"door_close":
			audio_stream_player_for_sound_effects = $SoundEffects/DoorClose
		"door_unlock":
			audio_stream_player_for_sound_effects = $SoundEffects/DoorUnlock
		"success":
			audio_stream_player_for_sound_effects = $SoundEffects/Success
		"failure":
			audio_stream_player_for_sound_effects = $SoundEffects/Failure
		_:
			push_error("Non esiste alcun effetto sonoro chiamato '{0}'".format([sound_effect_name]))
			return null

	return audio_stream_player_for_sound_effects


func _convert_sound_track_name_to_audio_stream_player(sound_track_name: String) -> AudioStreamPlayer:
	match sound_track_name:
		"Lullaby":
			audio_stream_player_for_sound_track = $SoundTracks/Lullaby
		"Dragonball":
			audio_stream_player_for_sound_track = $SoundTracks/Dragonball
		"Arale":
			audio_stream_player_for_sound_track = $SoundTracks/Arale
		_:
			push_error("Non esiste alcun effetto sonoro chiamato '{0}'".format([sound_track_name]))
			return null

	return audio_stream_player_for_sound_track
	
