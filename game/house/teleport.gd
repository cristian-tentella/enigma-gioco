extends Node


# Called when the node enters the scene tree for the first time.
func teleport_down():
	#if StateManager.player.body_entered():
	StateManager.player.set_position(Vector2(1200,800))

func teleport_up():
	StateManager.player.set_position(Vector2(210,710))
