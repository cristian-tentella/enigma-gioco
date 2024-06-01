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
			room.connect("body_entered", Callable(self, "_on_room_entered").bind(room.name))
			room.connect("body_exited", Callable(self, "_on_room_exited"))
			print("Segnale collegato per la stanza " + room.name)
			if room.name == current_room:
				room.get_node("ColorRect").color = LIGHT_ON
			else:
				room.get_node("ColorRect").color = LIGHT_OFF
				
	print("La stanza corrente e' " + rooms[current_room].name)

func _on_room_entered(body, room_name):	
	if body is Player:
		print("Sei entrato in " + room_name)
		current_room = room_name
		rooms[current_room].get_node("ColorRect").color = LIGHT_ON
	
func _on_room_exited(body):
	if body is Player:
		rooms[current_room].get_node("ColorRect").color = LIGHT_OFF


	

