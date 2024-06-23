class_name Card
extends Node2D

@onready var area = $Sprite2D/Area2D/CollisionShape2D
@onready var sprite2D = $Sprite2D
@onready var button = $Button
@onready var card_name_label = $Label
@export var card_name: String
@export_enum("regular", "bet", "extralife") var card_type: String
@export var description: String

var sprite_path: String
#@export var texture : sprite2D.texture

func _ready():
	card_name_label.text = card_name
	update_card_sprite2D_back_texture()
	#sprite2D.texture = texture
	
	
func update_card_sprite2D_front_texture():
#Carica l'immagine dell'oggetto
	sprite_path = "res://game/items/memeory_items/"+card_type+"/"+card_type+"_front.png"
	var image_texture = load(sprite_path)
	sprite2D.texture = image_texture
	
func update_card_sprite2D_back_texture():
	sprite_path = "res://game/items/memeory_items/card_back.png"
	var image_texture = load(sprite_path)
	sprite2D.texture = image_texture
	



