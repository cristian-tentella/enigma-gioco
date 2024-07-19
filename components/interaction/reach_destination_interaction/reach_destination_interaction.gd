class_name ReachDestinationInteraction
extends Interaction


@onready var real_interaction: OnCollisionAnyInteraction = $OnCollisionAnyInteraction
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@export_enum("Self") var go_to : String = "Self" #Reminder che va dove questo nodo è piazzato

func _ready():
	#Metti la collision shape come figlia della vera interazione
	self.move_collision_shape_from_self_to_onCollAnyInteraction()
	
	real_interaction.is_method_in_direct_parent = true
	real_interaction.method_name = "handle_interaction"

func move_collision_shape_from_self_to_onCollAnyInteraction():
	#ASSEGNA UNA COLLISION SHAPE COME FIGLIA DEL NODO ReachDestinationInteraction DELLA TUA SCENA!
	#Non cambiarle nome, chiamala CollisionShape2D .
	#NON QUI, NELLA TUA SCENA!
	assert(collision_shape != null) #Leggi qui sopra
	
	self.remove_child(collision_shape)
	self.real_interaction.add_child(collision_shape)

func handle_interaction():
	# Interaction logic
	UIManager.lock.emit() #NON FUNZIONA...
	#StateManager.should_player_be_able_to_move = false #Blocco lo user dal premere tasti, ora comando io!
	
	self.real_interaction.queue_free()
	
	self.move_to_target_destination(self.position)
	
	#UIManager.unlock.emit() #NON FUNZIONA...
	await move_to_target_destination_finished
	StateManager.should_player_be_able_to_move = true #Free again!
	
	_remove_if_proc_only_once()
	_increment_current_minigame_if_told_so()

signal move_to_target_destination_finished
func move_to_target_destination(target_destination: Vector2):
	var player_position = StateManager.player.position
	
	#==== MOVIMENTO SULLA X ====
	# [Player x = 100] -> [Dest x = 120] DEVE ANDARE A DESTRA (-20)
	if(player_position.x - target_destination.x < 0):
		print_debug("Moving right")
		_move_player_right_until_x_reached(target_destination.x)
	else:
		print_debug("Moving left")
		_move_player_left_until_x_reached(target_destination.x)
	#Se == 0, allora ci sto già!
	
	move_to_target_destination_finished.emit()


func _move_player_left_until_x_reached(target_x):
	
	InputManager._process_system_input_event(InputManager.MOVE_LEFT, true)
	await get_tree().create_timer(0.2).timeout #Se lo tolgo si blocca...?
	
	await StateManager.player.has_reached_system_destination
	
	InputManager._process_system_input_event(InputManager.MOVE_LEFT, false)
	

func _move_player_right_until_x_reached(target_x):
	while(StateManager.player.position.x != target_x):
		break
