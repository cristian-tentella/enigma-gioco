extends Node2D

@onready var rooms_node = $".."
var rooms = {}
const LIGHT_ON: Color = Color(0, 0, 0, 0) 
const LIGHT_OFF: Color = Color(0.12549, 0.117647, 0.113725, 1)
const Z_INDEX_VALUE = 100
const fade_duration = 0.3

func _ready():
	for room in rooms_node.get_children():
		if room is Room:
			rooms[room.name] = room
			room.body_entered.connect(_on_room_entered.bind(room.name))
			room.body_exited.connect(_on_room_exited.bind(room.name))
			room.get_node("ColorRect").color = LIGHT_OFF
			room.get_node("ColorRect").z_index = Z_INDEX_VALUE
			

func _on_room_entered(body, current_room):	
	if body is Player:
		var tween = create_tween()
		#rooms[current_room].get_node("ColorRect").color = LIGHT_ON
		tween.tween_property(rooms[current_room].get_node("ColorRect"), "color", LIGHT_ON, 0.2).set_ease(Tween.EASE_IN)
		
func _on_room_exited(body, previous_room):
	if body is Player:
		#rooms[previous_room].get_node("ColorRect").color = LIGHT_OFF
		var tween = create_tween()
		tween.tween_property(rooms[previous_room].get_node("ColorRect"), "color", LIGHT_OFF, 0.2).set_trans(Tween.TRANS_LINEAR)


		
