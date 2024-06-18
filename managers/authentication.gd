extends Node

signal exit
signal message(message: String)

var sleep_after_action:float = 0.7

@onready var authentication_menu: AuthenticationMenu = preload(
	"res://ui/authentication_menu/authentication_menu.tscn"
).instantiate()

func _ready():
	Supabase.auth.signed_up.connect(on_sign_up_succeeded)
	Supabase.auth.signed_in.connect(on_sign_in_succeeded)
	Supabase.auth.error.connect(on_sign_error)
	Supabase.auth.signed_out.connect(on_sign_out)
	
func sign_out():
	Supabase.auth.sign_out()


func sign_up(email, password):
	Supabase.auth.sign_up(email, password)
	
	
func sign_in(email, password):
	Supabase.auth.sign_in(email, password)
	

func on_sign_in_succeeded(user: SupabaseUser):
	await display_report_message(str(user.role))
	self.exit.emit()
	
func on_sign_up_succeeded(user: SupabaseUser):
	await display_report_message(str(user.role))
	self.exit.emit()
	
func on_sign_out():
	self.exit.emit()
	
	
func on_sign_error(error: SupabaseAuthError):
	await display_report_message(str(error.message))


func display_report_message(message:String):
	self.message.emit(message)
	await get_tree().create_timer(sleep_after_action).timeout
	

