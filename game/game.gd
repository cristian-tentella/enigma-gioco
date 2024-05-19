extends Node


@onready var player = $Player


func _ready():
	StateManager.player = player
