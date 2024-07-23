class_name Card
extends Control

#@onready var area = $Sprite2D/Area2D/CollisionShape2D
@onready var textureRect = $CenterContainer/TextureRect
@onready var button = $Button
#@onready var card_name_label = $Label
@export var card_name: String
@export_enum("regular", "watermelon", "extralife", "malus", "shuffle", "seer", "tcg","error") var card_type: String
@export var description: String
@export var index = 0;
@onready var clickable = true

var sprite_path: String

func _ready():
	#card_name_label.text = card_name
	update_card_sprite2D_back_texture()
	
	
func update_card_sprite2D_front_texture():
#Carica l'immagine frontale della carta
	sprite_path = "res://game/minigames/memeory/memeory_cards/"+card_type+"/"+card_type+"_front.png"
	var image_texture = load(sprite_path)
	textureRect.texture = image_texture
	
func update_card_sprite2D_back_texture():
	sprite_path = "res://game/minigames/memeory/memeory_cards/card_back.png"
	var image_texture = load(sprite_path)
	textureRect.texture = image_texture
	
func handle_interaction():
	pass





func _on_button_pressed():
	pass # Replace with function body.
