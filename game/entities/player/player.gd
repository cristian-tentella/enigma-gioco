class_name Player
extends CharacterBody2D


#Lo sprite del giocatore
@onready var animated_sprite = $AnimatedSprite2D
@onready var step_sound_effect_timer: Timer = $StepSoundEffectTimer

#Ha sottonodo CollisionShape2D che definisce l'area di interazione del giocatore. interaction/interaction_detector/interaction_detector.gd per info extra
#Al momento è un giga cerchio stabile intorno al giocatore
@onready var interaction_detector = $InteractionDetector 


@export_category("Settings")
@export_group("Movement constants")
@export var MAX_SPEED: float = 128
@export var ACCELERATION: float = 8
@export var FRICTION: float = 16

var input = Vector2.ZERO
var starting_position
const MOVEMENT_ACTIONS = ["move_left", "move_right", "move_up", "move_down"]
var movement_actions_queue: Array[String]


func _ready():
	starting_position = self.global_position
	InputManager.movement_action_pressed.connect(
		func(movement_action: String):
			self.movement_actions_queue.append(movement_action)
	)
	
	InputManager.movement_action_released.connect(
		func(movement_action: String):
			self.movement_actions_queue.erase(movement_action)
	)
	
	StateManager.player_can_move.connect(
		func(player_can_move: bool):
			if not player_can_move:
				self.movement_actions_queue.clear()
	)


func _physics_process(delta: float):
	update_input_vector()
	update_animated_sprite()
	update_step_sound_effect_timer()
	update_interaction_detector_position()
	update_velocity(delta)
	move_and_slide()


func update_velocity(delta: float):
	if is_idle():
		self.velocity = self.velocity.lerp(Vector2.ZERO, self.FRICTION * delta)
	
		#	AudioManager.play_step_sound_effect()
	else:
		self.velocity = self.velocity.lerp(
			self.MAX_SPEED * self.input.normalized(),
			self.ACCELERATION * delta,
		)

#When I receive an input, I place it as a Player variable
func update_input_vector():
	var new_input = Vector2.ZERO

	for movement_action in self.movement_actions_queue:
		new_input += get_vector_from_movement_action(movement_action)

	self.input = new_input


func update_animated_sprite():
	var current_animation_name: String = self.animated_sprite.animation
	
	var next_animation_name = current_animation_name
	if not self.movement_actions_queue.is_empty():
		next_animation_name = latest_movement_action()
	else:
		next_animation_name = current_animation_name.replace("move", "idle")

	self.animated_sprite.play(next_animation_name)


func update_step_sound_effect_timer():
	if is_idle():
		if not self.step_sound_effect_timer.is_stopped():
			self.step_sound_effect_timer.stop()
	else:
		if self.step_sound_effect_timer.is_stopped():
			self.step_sound_effect_timer.start()
			# Quando il giocatore inizia a camminare il primo suono di passi viene
			# riprodotto al primo timeout di StepSoundEffectTimer (dopo 0.5 secondi).
			# Ciò non è ideale in quanto rallenta eccessivamente il feedback sonoro
			# inviato al giocatore.
			#
			# Questa chiamata a play_step_sound_effect permette di far partire
			# il primo suono di passi nel momento esatto in cui il giocatore
			# inizia a muoversi.
			AudioManager.play_step_sound_effect()


func update_interaction_detector_position():
	if is_idle():
		return

	const offset_multiplier = 17
	self.interaction_detector.position = input * offset_multiplier


func get_vector_from_movement_action(movement_action: String):
	match movement_action:
		"move_left":
			return Vector2.LEFT
		"move_right":
			return Vector2.RIGHT
		"move_up":
			return Vector2.UP
		"move_down":
			return Vector2.DOWN


func latest_movement_action() -> String:
	return self.movement_actions_queue.back()


func is_idle() -> bool:
	return self.input == Vector2.ZERO


func _on_step_sound_effect_timer_timeout():
	AudioManager.play_step_sound_effect()

#Funzioni utili per cambiare temporaneamente le variabili di movimento del player
#Usate in InputManager per _process_system_input_event()
func get_movement_constants():
	return [MAX_SPEED, ACCELERATION, FRICTION]

func set_movement_constants(movement_constants):
	self.MAX_SPEED = movement_constants[0]
	self.ACCELERATION = movement_constants[1]
	self.FRICTION = movement_constants[2]

func clear_movement_queue():
	self.movement_actions_queue.clear()
