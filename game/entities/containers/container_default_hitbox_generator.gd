#class_name ContainerDefaultHitboxGenerator # è un singleton Autoloaded

func generate_default_hitboxes(container: MyContainer):
	var container_name : String = container.container_name #In base al nome del container, che è il suo tipo, ho valori default diversi
	
	match container_name:
		"door_front":
			_generate_default_door_front_hitboxes()
		"door_side_left_handle", "door_side_right_handle": #Sono uguali
			_generate_default_door_side_hitboxes()


func _generate_default_door_front_hitboxes():
	pass
	
func _generate_default_door_side_hitboxes():
	pass
