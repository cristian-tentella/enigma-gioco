class_name AudioPlayer
extends Node


const LOWEST_VOLUME_IN_DECIBELS = -36
@export var sound_track_fade_in_duration_in_seconds = 2
var current_sound_track_player: AudioStreamPlayer

func _ready():
	AudioManager.play_sound_effect.connect(_on_audio_manager_play_sound_effect)
	AudioManager.play_sound_track.connect(_on_audio_manager_play_sound_track)
	AudioManager.stop_sound_track.connect(_on_stop_sound_track)


func _on_audio_manager_play_sound_effect(sound_effect_name: String):
	var player: AudioStreamPlayer = _convert_sound_effect_name_to_audio_stream_player(sound_effect_name)

	# audio_stream_player è null quando _convert_sound_effect_name_to_audio_stream_player
	# è stata chiamata con un sound_effect_name che non corrisponde a nessun
	# effetto sonoro tra quelli a disposizione
	if player == null:
		return

	player.play()


func _on_audio_manager_play_sound_track(sound_track_name: String):
	var player: AudioStreamPlayer = _convert_sound_track_name_to_audio_stream_player(sound_track_name)

	# audio_stream_player è null quando _convert_sound_track_name_to_audio_stream_player
	# è stata chiamata con un sound_track_name che non corrisponde a nessuna
	# colonna tra quelle a disposizione
	if player == null:
		return


	var correct_volume_in_decibels = 0
	self.current_sound_track_player = player
	player.set_volume_db(LOWEST_VOLUME_IN_DECIBELS)
	player.play()
	var tween = create_tween()
	tween.tween_property(player, "volume_db", correct_volume_in_decibels, sound_track_fade_in_duration_in_seconds)
	await tween.finished

func _on_stop_sound_track():
	var player = self.current_sound_track_player
	var tween = create_tween()
	tween.tween_property(player, "volume_db", LOWEST_VOLUME_IN_DECIBELS, sound_track_fade_in_duration_in_seconds)
	await tween.finished

	player.stop()


func _convert_sound_effect_name_to_audio_stream_player(sound_effect_name: String) -> AudioStreamPlayer:
	match sound_effect_name:
		"click":
			return $SoundEffects/Click
		"step":
			var footsteps = [
				$SoundEffects/Footstep1,
				$SoundEffects/Footstep2,
				$SoundEffects/Footstep3,
				$SoundEffects/Footstep4
			]
			return footsteps[randi() % footsteps.size()]
		"dialogue_ploop":
			var ploops = [
				$SoundEffects/DialoguePloop1,
				$SoundEffects/DialoguePloop2,
				$SoundEffects/DialoguePloop3,
				$SoundEffects/DialoguePloop4,
			]
			return ploops[randi() % ploops.size()]
		"item_pickup":
			return $SoundEffects/ItemPickup
		"menu":
			return $SoundEffects/Menu
		"door_open":
			return $SoundEffects/DoorOpen
		"door_close":
			return $SoundEffects/DoorClose
		"door_unlock":
			return $SoundEffects/DoorUnlock
		"success":
			return $SoundEffects/Success
		"failure":
			return $SoundEffects/Failure
		"keyboard":
			return $SoundEffects/Keyboard
		"pew":
			return $SoundEffects/Pew
		"key_turning":
			return $SoundEffects/KeyTurning
		"staircase":
			return $SoundEffects/Staircase
		"light_saber":
			return $SoundEffects/LightSaber
		"reset":
			return $SoundEffects/Reset
		"laser_sword_power_on":
			return $SoundEffects/LaserSwordPowerOn
		"engine_revving":
			return $SoundEffects/EngineRevving
		_:
			push_error("Non esiste alcun effetto sonoro chiamato '{0}'".format([sound_effect_name]))
			return null


func _convert_sound_track_name_to_audio_stream_player(sound_track_name: String) -> AudioStreamPlayer:
	match sound_track_name:
		"StartMenu":
			return $SoundTracks/StartMenu
		"main_theme":
			return $SoundTracks/MainTheme
		_:
			push_error("Non esiste alcuna colonna sonora chiamata '{0}'".format([sound_track_name]))
			return null
