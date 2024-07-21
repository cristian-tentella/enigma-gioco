class_name Card
extends Node2D

@onready var area = $Sprite2D/Area2D/CollisionShape2D
@onready var sprite2D = $Sprite2D
@onready var button = $Button
@onready var card_name_label = $Label
@export var card_name: String
@export_enum("regular", "bet", "extralife", "malus", "shuffle", "seer") var card_type: String
@export var description: String
@export var index = 0;
@onready var clickable = true

var sprite_path: String

func _ready():
	card_name_label.text = card_name
	update_card_sprite2D_back_texture()
	
	
func update_card_sprite2D_front_texture():
#Carica l'immagine frontale della carta
	sprite_path = "res://game/minigames/memeory/memeory_cards/"+card_type+"/"+card_type+"_front.png"
	var image_texture = load(sprite_path)
	sprite2D.texture = image_texture
	
func update_card_sprite2D_back_texture():
	sprite_path = "res://game/minigames/memeory/memeory_cards/card_back.png"
	var image_texture = load(sprite_path)
	sprite2D.texture = image_texture
	
func handle_interaction():
	pass



