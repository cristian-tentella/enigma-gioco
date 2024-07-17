class_name House
extends Node2D

func _ready():
	"""SETUP PER PRIMO MINIGIOCO, ATTENZIONE A COME SONO MESSI I NODI NELLA SCENA!"""
	MinigameManager.porta_camera_da_letto = $"Rooms/Cameretta + Terrazzo"
