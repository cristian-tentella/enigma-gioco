class_name Card
extends Node2D

@onready var card_name_label = $Label
@export var card_name: String

func _ready():
	card_name_label.text = card_name
