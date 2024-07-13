extends Node2D


const DEFAULT_Z_INDEX_VALUE = 100
const FADE_DURATION_IN_SECONDS = 0.3

const LIGHT_ON_COLOR_HEX = 0x00000000
const LIGHT_OFF_COLOR_HEX = 0x201e1dff

var room_name_to_room_area = {}


func _ready():
	_init_rooms()


func _init_rooms():
	for room in get_tree().get_nodes_in_group("Rooms"):
		room_name_to_room_area[room.name] = room

		room.body_entered.connect(_on_room_entered.bind(room.name))
		room.body_exited.connect(_on_room_exited.bind(room.name))

		var room_color_polygon = room.get_node("Color")
		room_color_polygon.color = Color.hex(LIGHT_OFF_COLOR_HEX)
		room_color_polygon.z_index = DEFAULT_Z_INDEX_VALUE


func _on_room_entered(body: Node2D, current_room_name: String):
	if body is Player:
		_tween_room_color(current_room_name, Color.hex(LIGHT_ON_COLOR_HEX), true)


func _on_room_exited(body: Node2D, previous_room_name: String):
	if body is Player:
		_tween_room_color(previous_room_name, Color.hex(LIGHT_OFF_COLOR_HEX), false)


func _tween_room_color(room_name: String, target_color: Color, ease_in: bool):
	var tween = create_tween()
	
	tween.tween_property(
		room_name_to_room_area[room_name].get_node("Color"),
		"color",
		target_color,
		FADE_DURATION_IN_SECONDS
	)

	if ease_in:
		tween.set_ease(Tween.EASE_IN)
