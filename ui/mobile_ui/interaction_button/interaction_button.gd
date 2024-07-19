extends TextureButton

var event = InputEventAction.new()

func _on_pressed():
	event.action = "interact"
	event.pressed = true
	Input.parse_input_event(event)
