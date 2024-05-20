extends Node


@onready var player = $Player
@onready var house = $House


func _ready():
	StateManager.player = player
	StateManager.house = house

	GameManager.start()
