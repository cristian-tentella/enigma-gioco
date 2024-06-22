extends Node2D

@onready var rooms_node = $".."
var rooms = {}
const LIGHT_ON: Color = Color(0, 0, 0, 0) 
const LIGHT_OFF: Color = Color(0, 0, 0, 1) 

func _ready():
	for room in rooms_node.get_children():
		if room is Room:
			rooms[room.name] = room
			room.body_entered.connect(_on_room_entered.bind(room.name))
			room.body_exited.connect(_on_room_exited.bind(room.name))
			room.get_node("ColorRect").color = LIGHT_OFF
				
	

func _on_room_entered(body, current_room):	
	if body is Player:
		rooms[current_room].get_node("ColorRect").color = LIGHT_ON
	
func _on_room_exited(body, previous_room):
	if body is Player:
		rooms[previous_room].get_node("ColorRect").color = LIGHT_OFF
