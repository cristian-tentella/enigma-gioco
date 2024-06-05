extends Node

signal exit

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
	print("ciao sei entrato")
	print(user)
	self.exit.emit()
	

func on_sign_up_succeeded(user: SupabaseUser):
	print("ciao sei registrato")
	print(user)
	self.exit.emit()
	
func on_sign_out():
	print("ciao sei uscito")
	self.exit.emit()
	
func on_sign_error(error: SupabaseAuthError):
	print(error)


