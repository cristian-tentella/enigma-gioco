"""
Container

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

extends AnimatedSprite2D

# Lista dei possibili requisiti di sblocco
enum RequirementType {
	NONE,
	KEY,
	PASSWORD,
	ITEM
}

# Lista di tutti i possibili container, strettamente correlata alle folder che abbiamo nel progetto dentro res://game/entities/containers/
enum ContainerNames {
	door
}
# Mappatura da enum a stringa per poter usare gli enum come, appunto, stringa
var ContainerNamesString = {
	ContainerNames.door: "door"
}

@onready var lock_sprite_image = $lock_sprite_image
@export var container_name: ContainerNames = ContainerNames.door
@export_category("Lock Settings")
@export var is_locked: bool = false
@export_group("Requirements")
@export var requirement_type: RequirementType = RequirementType.NONE # Variables to hold the requirement type and associated data
@export var requirement_data: ItemResource



func _ready():
	# Carica le animazioni dello specifico container
	_load_and_apply_animations_on_startup()
	# Esegui le azioni relative a cosa deve fare la porta se è bloccata o no
	update_door_state()

func update_door_state():
	if is_locked:
		lock_sprite_image.texture = preload("res://game/entities/containers/lock.png")
	else:
		pass
		# Add logic to show the door as unlocked (e.g., change sprite or animation)
		
func _load_and_apply_animations_on_startup():
	var container_name_string = ContainerNamesString[container_name] as String
	var container_animation_frames_path = "res://game/entities/containers/"+container_name_string+"/"+container_name_string+"_animations.tres"
	var sprite_frames = load(container_animation_frames_path)

	if sprite_frames:
		print(self.sprite_frames)
		self.sprite_frames = sprite_frames
		print(self.sprite_frames)
		self.animation = "closed"


func try_to_unlock(requirement: Variant) -> bool:
	if is_locked == false:
		return true
	match requirement_type:
		RequirementType.NONE:
			is_locked = false
		RequirementType.KEY:
			#if requirement == requirement_data:
				is_locked = false
		RequirementType.PASSWORD:
			#if requirement == requirement_data:
				is_locked = false
		RequirementType.ITEM:
			#if requirement == requirement_data:
				is_locked = false
		_:
			is_locked = true
	
	update_door_state()
	return not is_locked

