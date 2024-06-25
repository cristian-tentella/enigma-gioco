extends Node

signal exit
signal message(message: String)


var sleep_after_action = 0.7
var access_token_path = "user://user.auth"


@onready var authentication_menu: AuthenticationMenu = preload(
	"res://ui/authentication_menu/authentication_menu.tscn"
).instantiate()

func _ready():
	Supabase.auth.signed_up.connect(on_sign_up_succeeded)
	Supabase.auth.signed_in.connect(on_sign_in_succeeded)
	Supabase.auth.error.connect(on_sign_error)
	Supabase.auth.signed_out.connect(on_sign_out)
	Supabase.auth.reset_email_sent.connect(on_reset_succeded)
	Supabase.database.error.connect(on_database_query_error)
	check_if_access_token_exists()

	
func sign_out():
	Supabase.auth.sign_out()


func sign_up(email: String, password: String):
	var query_result = await add_entry_to_supabase_public_database(email)
	await Supabase.database.inserted
	Supabase.auth.sign_up(email, password)


func add_entry_to_supabase_public_database(user_email: String):
	var query = SupabaseQuery.new().from("Users").insert([{"email" : user_email}])
	Supabase.database.query(query)


func recover_password(email : String):
	Supabase.auth.reset_password_for_email(email)


func on_database_query_error(body):
	await display_report_message(body)	
	
	
func sign_in(email: String, password: String):
	Supabase.auth.sign_in(email, password)
	

func on_sign_in_succeeded(auth: SupabaseUser): 
	save_auth_token_to_encrypted_file(auth)
	await display_report_message(str(auth.role))
	self.exit.emit()
	
	
func on_sign_up_succeeded(auth: SupabaseUser):
	save_auth_token_to_encrypted_file(auth)
	await display_report_message(str(auth.role))
	self.exit.emit()
	
	
func on_reset_succeded():
	await display_report_message("An email has been sent to the speciefied email")
	await display_report_message("Go back and try to log in again")
	
	
func on_sign_out():
	self.exit.emit()
	
	
func on_sign_error(error: SupabaseAuthError):
	await display_report_message(str(error.message))


func display_report_message(report_message: String):
	self.message.emit(report_message)
	await get_tree().create_timer(sleep_after_action).timeout
	
	
func save_auth_token_to_encrypted_file(auth: SupabaseUser):
	var encrypted_file = FileAccess.open_encrypted_with_pass(access_token_path, FileAccess.WRITE, Supabase.config.supabaseKey)
	if encrypted_file.get_error() != OK:
		await display_report_message("An error occured while trying to securely store the access token")
	else:
		encrypted_file.store_line(JSON.stringify(auth.refresh_token))
		encrypted_file.store_line(JSON.stringify(auth.expires_in))
		encrypted_file.close()


func check_if_access_token_exists():
	if FileAccess.file_exists(access_token_path):
		retrieve_access_token_from_file()


func retrieve_access_token_from_file():
	var encrypted_file_with_access_token = FileAccess.open_encrypted_with_pass(access_token_path, FileAccess.READ, Supabase.config.supabaseKey)
	
	if encrypted_file_with_access_token == null:
		await get_tree().create_timer(0.01).timeout #Without this line the error message will not be shown
		await display_report_message("An error occured while decrypting the access token")
	else:
		construct_body_request(encrypted_file_with_access_token)
		
#
func construct_body_request(encrypted_file_with_access_token: FileAccess):
		var refresh_token: String = encrypted_file_with_access_token.get_line().strip_edges()
		if refresh_token.begins_with('"') and refresh_token.ends_with('"'):
			refresh_token = refresh_token.substr(1, refresh_token.length() - 2)
		var url = Supabase.config.supabaseUrl + SupabaseAuth._refresh_token_endpoint
		var headers = Supabase.auth._header
		var body = {
			"refresh_token": refresh_token
		}
		var json_body = JSON.stringify(body)
		make_request_to_load_auth(url, headers, json_body)


func make_request_to_load_auth(url: String, headers: PackedStringArray, json_body: String):
		var http_request = HTTPRequest.new()
		add_child(http_request)
		http_request.request_completed.connect(_on_refresh_completed)
		http_request.request(url, headers, HTTPClient.METHOD_POST, json_body)
		
		
func _on_refresh_completed(_result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray):
	if response_code == 200:
		var json_result = JSON.parse_string(body.get_string_from_utf8())
		Supabase.auth._auth = json_result.get("access_token")
		Supabase.auth._expires_in = json_result.get("expires_in")
		Supabase.auth.refresh_token(Supabase.auth._auth, Supabase.auth._expires_in)
		await display_report_message("Already Authenticated")
		self.exit.emit()
	else:
		var response_message = "Request failed with response code: " + str(response_code)
		await display_report_message(response_message)
		
		


