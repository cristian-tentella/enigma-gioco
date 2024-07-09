extends Node

"""
MinigameManager

TODO: Mettilo nei singleton, e fai il manager in generale.
"""

var current_minigame = 0 #This gets updated when a new minigame is started

var all_exited_interactions: Array[String] #Array che contiene tutte le interazioni uscite, quindi quelle che non devono essere ricliccate
