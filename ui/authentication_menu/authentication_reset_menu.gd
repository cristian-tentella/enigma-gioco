class_name AuthenticationResetMenu
extends Control

@onready var email = $CenterContainer/VBoxContainer/Email
@onready var report_message = $CenterContainer/VBoxContainer/ReportMessage


func _ready():
	AuthenticationManager.message.connect(_show_report_message)

func _on_send_reset_button_pressed():
	if email.text.contains("@"):
		AuthenticationManager.recover_password(email.text)

func _show_report_message(message: String):
	report_message.text = message
