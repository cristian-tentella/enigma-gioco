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
	UIManager.lock.emit()   #Blocco lo user dal premere tasti, ora comando io!
	
	self.real_interaction.queue_free()
	
	self.move_to_target_destination(self.position)
	
	#UIManager.unlock.emit() #NON FUNZIONA...
	await move_to_target_destination_finished
	
	UIManager.unlock.emit() #Free again!
	
	_remove_if_proc_only_once()
	_increment_current_minigame_if_told_so()

signal move_to_target_destination_finished
signal generic_movement_done
func move_to_target_destination(target_destination: Vector2):
	var player_position = StateManager.player.position
	
	#==== MOVIMENTO SULLA X ====
	# [Player x = 100] -> [Dest x = 120] DEVE ANDARE A DESTRA (-20)
	if(player_position.x - target_destination.x < 0):
		_move_player_right_until_x_reached(target_destination.x)
		await generic_movement_done
	else:
		_move_player_left_until_x_reached(target_destination.x)
		await generic_movement_done
	#Se == 0, allora ci sto già!

	#==== MOVIMENTO SULLA Y ====
	# [Player y = 100] -> [Dest y = 120] DEVE ANDARE A SOPRA (+20)
	if(player_position.y - target_destination.y < 0):
		_move_player_down_until_y_reached(target_destination.y)
		await generic_movement_done
	else:
		_move_player_up_until_y_reached(target_destination.y)
		await generic_movement_done
	#Se == 0, allora ci sto già!
	
	move_to_target_destination_finished.emit()


func _move_player_left_until_x_reached(target_x):
	
	InputManager._process_system_input_event(InputManager.MOVE_LEFT, true)
	
	while(StateManager.player.position.x > target_x):
		await get_tree().create_timer(0.00001).timeout #Se lo tolgo si blocca...?
	
	InputManager._process_system_input_event(InputManager.MOVE_LEFT, false)
	generic_movement_done.emit()

func _move_player_right_until_x_reached(target_x):
	
	InputManager._process_system_input_event(InputManager.MOVE_RIGHT, true)
	
	while(StateManager.player.position.x < target_x):
		await get_tree().create_timer(0.00001).timeout #Se lo tolgo si blocca...?
	
	InputManager._process_system_input_event(InputManager.MOVE_RIGHT, false)
	generic_movement_done.emit()

func _move_player_down_until_y_reached(target_y):
	
	InputManager._process_system_input_event(InputManager.MOVE_DOWN, true)
	
	while(StateManager.player.position.y < target_y):
		await get_tree().create_timer(0.00001).timeout #Se lo tolgo si blocca...?
	
	InputManager._process_system_input_event(InputManager.MOVE_DOWN, false)
	generic_movement_done.emit()

func _move_player_up_until_y_reached(target_y):
	
	InputManager._process_system_input_event(InputManager.MOVE_UP, true)
	
	while(StateManager.player.position.y > target_y):
		await get_tree().create_timer(0.00001).timeout #Se lo tolgo si blocca...?
	
	InputManager._process_system_input_event(InputManager.MOVE_UP, false)
	generic_movement_done.emit()