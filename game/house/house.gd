class_name House
extends Node2D

func _ready():
	"""SETUP PER PRIMO MINIGIOCO, ATTENZIONE A COME SONO MESSI I NODI NELLA SCENA!"""
	MinigameManager.porta_camera_da_letto = $"Rooms/Cameretta + Terrazzo/porta_camera"
	
	"""SETUP PER SECONDO MINIGIOCO, ATTENZIONE A COME SONO MESSI I NODI NELLA SCENA!"""
	MinigameManager.polipetto = $Rooms/Bagno/polipetto
	
	"""SETUP PER TERZO MINIGIOCO, ATTENZIONE A COME SONO MESSI I NODI NELLA SCENA!"""
	MinigameManager.plutonio_radioattivo = $Rooms/Studio/plutonio_radioattivo
