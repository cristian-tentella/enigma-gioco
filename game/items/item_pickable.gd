extends Node2D

var player_in_area = false

@export var item: GenericItem
var player = null
var picked = null

signal pressed()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player_in_area:
		if Input.is_action_just_pressed("pick"):
			if !picked:
				pick_item()
				await get_tree().create_timer(0.4).timeout
				queue_free()

func _on_click_pressed():
	pressed.emit()
	
func _on_pickable_area_body_entered(body):
	if body.has_method("player"):
		player_in_area = true
		player = body

func _on_pickable_area_body_exited(body):
	if body.has_method("player"):
		player_in_area = false


func pick_item():
	$AnimationPlayer.play("item_pick")
	picked = true
	player.collect(item)
	
