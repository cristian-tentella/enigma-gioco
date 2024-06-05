class_name AuthenticationMenu
extends Control

@onready var email = $email
@onready var password = $password

signal exit

func _on_sign_up_button_pressed():
	AuthenticationManager.sign_up(email.text, password.text)
	

func _on_sign_in_button_pressed():
	AuthenticationManager.sign_in(email.text, password.text)
	


