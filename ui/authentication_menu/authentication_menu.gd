class_name AuthenticationMenu
extends Control

@onready var email = $VBoxContainer/Email
@onready var password = $VBoxContainer/Password
@onready var report_message = $VBoxContainer/ReportMessage


func _ready():
	AuthenticationManager.message.connect(_show_report_message)

func _on_sign_up_button_pressed():
	AuthenticationManager.sign_up(email.text, password.text)
	
func _on_sign_in_button_pressed():
	AuthenticationManager.sign_in(email.text, password.text)
	
func _show_report_message(message: String):
	report_message.text = message

func _on_reset_password_button_pressed():
	AuthenticationManager.exit.emit()
