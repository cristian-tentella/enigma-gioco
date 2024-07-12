"""extends Node


#Instantiation of all minigames


@onready var minigame_1 = preload(
	"res://game/minigames/minigame_1/minigame_1_key_combination.tscn"
).instantiate()


##########################################################

@onready var minigame_elements: Array = [
	minigame_1
]




INUTILE PER ORAAAAAAAAAAAAAAAAAAAAAAAAAAAAA




func _ready():
	for minigame_element in minigame_elements:
		#minigame_element.hide()
		self.add_child(minigame_element)
"""


