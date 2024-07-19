"""
Script associato a game/game.tscn

Sul caricamento della scena, che è quella iniziale, il metodo _ready() viene chiamato e sono inizializzate le variabili essenziali, e fatto partire il gioco.
"""

extends Node

@onready var player = $Player/Player
@onready var house = $House
@onready var inventory_UI = UIManager.inventory_menu
@onready var memeory_UI = UIManager.memeory_menu
@onready var player_phantom_camera = %PlayerPhantomCamera2D
@onready var ui_phantom_camera = %PhantomCamera2D
@onready var audio_player = $AudioPlayer
@onready var joystick = $UI/MobileOnlyUI/VirtualJoystick

"""####################################################################################
WHOLE GAME ENTRY POINT (First scene called is game.tscn)
####################################################################################"""
#Primissimo metodo che viene  dopo il caricamento di game.tscn
func _ready():
	#Associare allo StateManager i riferimenti agli oggetti principali che creiamo, importantissimo per il comportamento generale!
	StateManager.player = player
	StateManager.house = house
	StateManager.player_phantom_camera = player_phantom_camera
	StateManager.ui_phantom_camera = ui_phantom_camera
	InputManager.joystick = joystick
	#SaveManager.load_game_save_from_json() #Lo fa dentro GameManager.start()

	
	#StateManager.inventory_UI = inventory_UI #Settati nel SaveManager
	#StateManager.inventory = inventory_UI.inv #Settati nel SaveManager

	StateManager.audio_player = audio_player

	#Cuore del gioco, il GameManager.start() è da dove tutto ha inizio (molto filosofica, come cosa)
	GameManager.start()
