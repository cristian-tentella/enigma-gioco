extends Node2D

@onready var rooms_node = $".."
var current_room = "Bagno"
var rooms = {}
const LIGHT_ON: Color = Color(0, 0, 0, 0) 
const LIGHT_OFF: Color = Color(0, 0, 0, 1) 

func _ready():
	for room in rooms_node.get_children():
		if room is Room:
			rooms[room.name] = room
			room.body_entered.connect(_on_room_entered.bind(room.name))
			room.body_exited.connect(_on_room_exited)
			if room.name == current_room:
				room.get_node("ColorRect").color = LIGHT_ON
			else:
				room.get_node("ColorRect").color = LIGHT_OFF
				
	

func _on_room_entered(body, room_name):	
	if body is Player:
		current_room = room_name
		rooms[current_room].get_node("ColorRect").color = LIGHT_ON
	
func _on_room_exited(body):
	if body is Player:
		rooms[current_room].get_node("ColorRect").color = LIGHT_OFF


	

