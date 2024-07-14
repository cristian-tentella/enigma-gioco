class_name LoadingScreen
extends Control

@onready var progress_bar: TextureProgressBar = $CenterContainer/TextureProgressBar

signal exit

#Inizializza con value a 0
func _ready():
	return
	self.progress_bar.value = 0


func add_to_value(value_to_add: int):
	self.set_value(self.progress_bar.value + value_to_add)
	self.check_if_full()

func set_value(new_value: int):
	self.progress_bar.value = new_value

func check_if_full():
	if (progress_bar.value == 100):
		self.exit.emit()
		self.progress_bar.value = 0 #resetto per la prossima volta in cui può servire

func exit_from_loading_screen_evenly():
	await self.set_value(100) #Prima faccio vedere 100 cosi è figo
	self.exit.emit()
