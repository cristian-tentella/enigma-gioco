class_name MyContainer
extends AnimatedSprite2D

"""
MyContainer

Classe che riguarda tutti gli oggetti che si aprono e chiudono del gioco.

Per impostare container bloccato, selezionare dal menu di ispezione, sotto la categoria "Lock Settings", la prima di tutte:
	is_locked = metti la flag di "on"
	
	Requirements:
		requirement_type = (scegli tra i disponibili)
		requirement_data = (un oggetto che serve)


Per selezionare il tipo di container, sceglierlo dall'inspector a destra, selezionando "Container Name"

Ad esempio:
	Voglio una porta
		1) Trascino la scena container.tscn nella scena dove mi serve la porta, tipo la scena "cucina.tscn"
		2) Seleziono dall'inspector a destra le proprietà della porta
		3) Chiamo la scena che rappresenta la porta "door", perché ho res://game/entities/containers/door
		4) Il png della porta si deve chiamare necessariamente door.png, come la folder


GESTIONE DELLE ANIMAZIONI:
	
	Le animazioni consentite sono "opened" e "closed".
	1) Creare una scena temporanea con un nodo AnimatedSprite2D, e creare i frame di animazioni necessari.
	2) Cliccare sul nodo AnimatedSprite2D con le animazioni messe, e sull'inspector a destra andare su "Sprite Frames", e cliccare la freccia del menu a tendina tutta a dx
	3) Cliccare "save as", e salvare col nome dell'oggetto e _animations (ad esempio door_animations.tres), dentro alla folder dedicata al tuo container (es. door)
	4) Finito, eliminare la scena temporanea
"""

@onready var lock_sprite_image = $lock_sprite_image
@onready var static_body = $StaticBody2D
@onready var container_interaction = $ContainerInteraction

"""
SE VUOI USARE INTERAZIONI CUSTOM, CREA NODI "COLLISIONSHAPE2D" COME FIGLI DEL CONTAINER CHE VUOI USARE.
Ovviamente NON dentro container.tscn ma dentro la scena in cui usi la porta.

Se usi un solo CollisionShape2D per interazione e collisione, flagga "same_shape_for_both"

Se usi uno per l'interazione (dove clicchi) e uno per la collisione (dove sbatti):
	il nodo CollisionShape2D dell'interazione si chiama "area_di_interazione"
	il nodo CollisionShape2D della collisione si chiama "area_dove_sbatto"
"""
@export_category("Container settings")
@export var description_of_above: String = "guarda game/containers/container.gd"
@export var is_open_at_startup: bool = false
@export_enum("door") var container_name: String
@export_group("Editor shapes settings")
@export var use_editor_collision_shape : bool = false
@export var same_shape_for_both: bool = true
@export_enum("area_di_interazione", "area_dove_sbatto", "vedi il tutorial.") var use_these_names_for_nodes: String
"Se vuoi usare un CollisionShape2D fatto nell'editor, NON CAMBIARGLI NOME, e mettilo come figlio del container stesso nella tua scena"
@export_category("Rectangle collision values")
@export var container_collision_rect_x : int = -1 #Negative means default
@export var container_collision_rect_y : int = -1 #Negative means default
@export_category("Lock Settings")
@export var is_locked: bool = false
@export_group("Requirements")
@export_enum("set_of_keys") var requirement_type: String # Variables to hold the requirement type and associated data
@export_group("Key settings, if key is the unlock item")											#TODO: remove
@export_range(0,8) var required_key_number : int = 0 #Zero if key is not the unlocking item			#TODO: remove
@export_group("Other items requirements (to be implemented)")
@export var required_item_name: String #MUST BE THE NAME THAT IS IN THE .tres FILE OF THE ITEM ON "item_name" ENTRY. We do inventory search like this, maybe?

var physical_collision_shape
var rect_shape_static

func _ready():
	_load_and_apply_animations_on_startup()
	if use_editor_collision_shape:
		if same_shape_for_both: 
			_generate_both_collision_shapes_from_editor_node()
		else:
			_generate_both_collision_shapes_from_two_editor_nodes()
	else:
		_generate_both_collision_rectangles_from_exported_vars()
	
func free_lock_sprite_image_node():
	lock_sprite_image.queue_free()
	
func remove_physical_collision():
	physical_collision_shape.shape = null

func restore_physical_collision():
	physical_collision_shape.shape = rect_shape_static

# Stessi print in parti diverse, li ho messi a fattor comune, move forward
func _print_tutorial_errors():
	print_debug("\n\tERROR] GENERATION OF ", get_name(), " FROM NODE FAILED. A CONTAINER HAS NO HITBOXES. Did you put a CollisionShape2D child in the scene he's used in?\n\tIf you did not mean to use a editor CollisionShape2D, make sure to unflag the exported variable 'use_editor_collision_shape' in container scene")
	print("\n")

func _handle_physical_collision_creation_with_given_collision(editor_collision_shape_2D_node: CollisionShape2D):
	physical_collision_shape = editor_collision_shape_2D_node.duplicate()
	rect_shape_static = physical_collision_shape.shape
	static_body.add_child(physical_collision_shape)

#Se si ha flaggato "use_editor_collision_shape" e "same_shape_for_both"
func _generate_both_collision_shapes_from_editor_node():
	var editor_collision_shape_2D_node = $CollisionShape2D
	
	#Guard if forgor collision node
	if editor_collision_shape_2D_node == null:
		_print_tutorial_errors()
		return
	_handle_physical_collision_creation_with_given_collision(editor_collision_shape_2D_node)
	editor_collision_shape_2D_node.queue_free()
	container_interaction.add_child(editor_collision_shape_2D_node.duplicate())

#Se si ha flaggato "use_editor_collision_shape" e non "same_shape_for_both"
func _generate_both_collision_shapes_from_two_editor_nodes():
	var editor_collision_shape_2D_node_interazione = $area_di_interazione
	if editor_collision_shape_2D_node_interazione == null: #Guardia per chi non ha letto il tutorial
		print_debug("IL NODO DELL'INTERAZIONE SI DEVE CHIAMARE NECESSARIAMENTE area_di_interazione")
		_print_tutorial_errors()
		return
	var editor_collision_shape_2D_node_collisione = $area_dove_sbatto
	if editor_collision_shape_2D_node_interazione == null: #Guardia per chi non ha letto il tutorial
		print_debug("IL NODO DELL'INTERAZIONE SI DEVE CHIAMARE NECESSARIAMENTE area_dove_sbatto")
		_print_tutorial_errors()
		return
	
	#Metti al giusto posto la collisione dove sbatto e elimina il nodo che non si usa più, quello iniziale
	_handle_physical_collision_creation_with_given_collision(editor_collision_shape_2D_node_collisione)
	editor_collision_shape_2D_node_collisione.queue_free()
	#Metti al giusto posto la collisione dove interagisco e elimina il nodo che non si usa più, quello iniziale
	container_interaction.add_child(editor_collision_shape_2D_node_interazione.duplicate())
	editor_collision_shape_2D_node_interazione.queue_free()

#Se si vuole generare tutti via editor
func _generate_both_collision_rectangles_from_exported_vars():
	var x =  container_collision_rect_x as int
	var y = container_collision_rect_y as int

	"""DEFAULT VALUES IF NEGATIVE IN INPUT"""
	if x < 0:
		x = 32
	if y < 0:
		y = 64
	
	#Generate Collision Shape for interaction
	var interaction_collision_shape = CollisionShape2D.new()
	CollisionShapeCreator.create_rect_shape(interaction_collision_shape, x, y)
	container_interaction.add_child(interaction_collision_shape)
	
	#Generate Collision Shape for physical collisions
	physical_collision_shape = CollisionShape2D.new()
	rect_shape_static = CollisionShapeCreator.create_rect_shape(physical_collision_shape, x, y)
	static_body.add_child(physical_collision_shape)


func _load_and_apply_animations_on_startup():
	"""CARICA GLI SPRITE FRAMES DEL CONTAINER ADEGUATO"""
	var container_animation_frames_path = "res://game/entities/containers/"+container_name+"/"+container_name+"_animations.tres" #La path per il file di animazioni
	var _sprite_frames = load(container_animation_frames_path) #Lo sprite di animazioni
	if _sprite_frames: #Se l'ha trovato (Lo deve aver trovato se sono stati rispettati i criteri di path)
		self.sprite_frames = _sprite_frames
		if is_open_at_startup:
			self.animation = "opened"
		else:
			self.animation = "closed"
	else:
		print("SPRITE FRAMES FOR "+container_name+" NOT LOADED! A CONTAINER HAS DEFAULT DOOR TEXTURE!\n")
	
	"""SE E' UN CONTAINER BLOCCATO, METTICI SOPRA LO SPRITE DEL LUCCHETTO, ALTRIMENTI CANCELLA IL NODO DALLA MEMORIA"""
	update_lock_state()

func update_lock_state():
	if is_locked:
		lock_sprite_image.texture = preload("res://game/entities/containers/lock.png")
	else:
		free_lock_sprite_image_node() #If the door is not locked, i do not need the sprite for the lock, free memory
		
		# Add logic to show the door as unlocked (e.g., change sprite or animation)

func unlock():
	self.is_locked = false
	free_lock_sprite_image_node() # Container not locked anymore, I do not need the node anymore
	self.animation = "opened"
	remove_physical_collision() # Fa in modo che se sia aperta ci puoi passare attraverso

func try_to_unlock() -> bool:
	#Guardia se la funzione viene invocata nonostante il container sia già sbloccato
	var is_unlocked = true
	if self.is_locked == false:
		return is_unlocked				#returna sempre vero perché il container è sbloccato
	else: 
		"""COMPORTAMENTO PER CONTAINER CHE SI DEVE TENTARE DI SBLOCCARE IN BASE AL REQUIREMENT"""
		match requirement_type:
			"set_of_keys":
				is_unlocked = StateManager.inventory.has_item("set_of_keys")
			"spada_laser_funzionante":
				is_unlocked = StateManager.inventory.has_item("spada_laser_funzionante")
	
	if is_unlocked:
		unlock()
	
	return is_unlocked


