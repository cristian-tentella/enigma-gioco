extends Node2D

@onready var launcher : OnCollisionAnyInteraction = $everything_launcher_collision_interaction

@onready var first_dialogue_on_wake_up : DialogueInteraction = $first_dialogue_on_wake_up

@onready var AUTOPILOT_da_letto_a_fuori: ReachDestinationInteraction = $AUTOPILOT_da_letto_a_fuori
@onready var AUTOPILOT_da_letto_a_fuori2: ReachDestinationInteraction = $AUTOPILOT_da_letto_a_fuori2

@onready var second_dialogue_after_autopilot: DialogueInteraction = $second_dialogue_after_autopilot

@onready var AUTOPILOT_da_fuori_a_dentro: ReachDestinationInteraction = $AUTOPILOT_da_fuori_a_dentro
@onready var AUTOPILOT_da_fuori_a_dentro2: ReachDestinationInteraction = $AUTOPILOT_da_fuori_a_dentro2

@onready var third_dialogue_tra_poliziotti: DialogueInteraction = $third_dialogue_tra_poliziotti

@onready var fourth_dialogue_con_daniel: DialogueInteraction = $fourth_dialogue_con_daniel


func launch_everything():
	
	await UIManager.start_menu_play_button_pressed
	await get_tree().create_timer(1.3).timeout
	
	if StateManager.current_minigame >= 0:# == -1 se è prima volta che inizio in assoluto quindi eseguo
		if is_instance_valid(self):
			self.queue_free()
		return
	
	#Fai partire dialogo appena sveglio
	self.first_dialogue_on_wake_up.handle_interaction()
	await DialogueManager.has_finished_displaying
	
	#Fai partire autopilot verso fuori
	self.AUTOPILOT_da_letto_a_fuori.handle_interaction()
	await UIManager.unlock
	self.AUTOPILOT_da_letto_a_fuori2.handle_interaction()
	await UIManager.unlock
	
	#Fai partire dialogo dopo autopilot
	self.second_dialogue_after_autopilot.handle_interaction()
	await DialogueManager.has_finished_displaying
	
	#Fai partire autopilot verso dentro
	self.AUTOPILOT_da_fuori_a_dentro.handle_interaction()
	await UIManager.unlock
	self.AUTOPILOT_da_fuori_a_dentro2.handle_interaction()
	await UIManager.unlock
	
	#Fai partire dialogo tra poliziotti
	self.third_dialogue_tra_poliziotti.handle_interaction()
	await DialogueManager.has_finished_displaying
	
	#Fai partire autopilot verso fuori
	self.AUTOPILOT_da_letto_a_fuori2.handle_interaction()
	await UIManager.unlock
	
	#Fai partire dialogo con daniel
	self.fourth_dialogue_con_daniel.handle_interaction()
	await DialogueManager.has_finished_displaying
	
	StateManager.current_minigame = 0
	StateManager.should_player_be_able_to_move = true

	self.queue_free()

