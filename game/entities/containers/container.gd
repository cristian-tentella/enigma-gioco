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
@onready var physical_collision_shape = $StaticBody2D/CollisionShape2D2
@onready var interaction_collision_shape = $ContainerInteraction/CollisionShape2D


@export_category("Container settings")
@export var is_open_at_startup: bool = false
@export_enum("door") var container_name: String
@export_category("Rectangle collision values")
@export var container_collision_rect_x : int = 32
@export var container_collision_rect_y : int = 64
@export_category("Lock Settings")
@export var is_locked: bool = false
@export_group("Requirements")
@export_enum("key") var requirement_type: String # Variables to hold the requirement type and associated data
@export_group("Key settings, if key is the unlock item")
@export_range(0,8) var required_key_number : int = 0 #Zero if key is not the unlocking item
@export_group("Other items requirements (to be implemented)")
@export var required_item_name: String #MUST BE THE NAME THAT IS IN THE .tres FILE OF THE ITEM ON "item_name" ENTRY. We do inventory search like this, maybe?

func _ready():
	# Carica le animazioni dello specifico container
	_load_and_apply_animations_on_startup()
	_resize_collision_shapes_according_to_exported_variable()

func _resize_collision_shapes_according_to_exported_variable():
	physical_collision_shape.shape.size.x = container_collision_rect_x
	physical_collision_shape.shape.size.y = container_collision_rect_y
	
	interaction_collision_shape.shape.size.x = container_collision_rect_x
	interaction_collision_shape.shape.size.y = container_collision_rect_y

func _load_and_apply_animations_on_startup():
	"""CARICA GLI SPRITE FRAMES DEL CONTAINER ADEGUATO"""
	var container_animation_frames_path = "res://game/entities/containers/"+container_name+"/"+container_name+"_animations.tres" #La path per il file di animazioni
	var sprite_frames = load(container_animation_frames_path) #Lo sprite di animazioni
	if sprite_frames: #Se l'ha trovato (Lo deve aver trovato se sono stati rispettati i criteri di path)
		self.sprite_frames = sprite_frames
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

func free_lock_sprite_image_node():
	lock_sprite_image.queue_free()

func unlock():
	self.is_locked = false #TODO: REMOVE
	free_lock_sprite_image_node() # Container not locked anymore, I do not need the node anymore #TODO: REMOVE
	self.animation = "opened" #TODO: REMOVE

func try_to_unlock() -> bool:
	#Guardia se la funzione viene invocata nonostante il container sia già sbloccato
	var true_if_unlocked = true
	if self.is_locked == false:
		return true_if_unlocked
	else: 
		"""COMPORTAMENTO PER CONTAINER CHE SI DEVE TENTARE DI SBLOCCARE IN BASE AL REQUIREMENT"""
		match requirement_type:
			"key":
				var key_locked_manager = KeyLockedContainerBehavior.new()
				true_if_unlocked = key_locked_manager.try_to_unlock(required_key_number)
	
	if true_if_unlocked:
		unlock()
	
	return true_if_unlocked
	
	
# Function to update CollisionPolygon2D based on current AnimatedSprite2D frame