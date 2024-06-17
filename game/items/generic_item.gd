# BaseItem.gd
extends Node2D

"""
TUTORIAL PER UTILIZZO DI OGGETTI ----------
Ogni oggetto è dato dalla scena generic_item.tscn
1) Creare la folder col nome del tuo oggetto nome_obj dentro res://items
2) Creare li dentro tre file:
	"nome_obj.tres" - Per farlo, right click sulla folder > crea nuovo > Risorsa... > seleziona ItemResource > crea
	"nome_obj.gd" - Lo script associato al comportamento dello specifico oggetto. NOTA: la funzione _ready() di quello script viene chiamata dalla scena generica, usala!
	"nome_obj.png" - La texture dell'oggetto
3) Andare nel file .tres con un text editor esterno, e modificarlo secondo le direttive dentro items/item_resource.gd

"""
""""""
@onready var item_interaction = $ItemInteraction
@onready var static_body_2D = $StaticBody2D
@onready var sprite2D = $Sprite2D

@export_category("Item Values")
@export var collision_circle_radius : int = -1 #Lasciare numero negativo se si vuole usare quello del .tres
@export_enum("set_of_keys", "set_of_keys2") var item_name: String
"""
UPDATE QUESTO OGNI VOLTA CHE SI INSERISCE UN ITEM SPECIFICO
"""

var item_resource

func _ready():
	""" 
	IL NOME DEL NODO NELLA SCENA DEFINISCE L'ITEM CHE VUOI CHE SIA.
	FAI ATTENZIONE CHE LA FOLDER DELL'ITEM SI CHIAMI nome_item E CHE IL .tres ABBIA LA FORMA nome_item.tres
	(Segui il tutorial di generic_item.gd e item_resource.gd
	)
	esempio:
		voglio l'item mazzo_di_chiavi :
			dentro items c'è una folder mazzo_di_chiavi, al cui interno c'è il file mazzo_di_chiavi.tres
			RISPETTA RIGOROSAMENTE QUESTA SINTASSI!
	""" 
	var tres_path = "res://game/items/" + item_name + "/" + item_name + ".tres"
	item_resource = load(tres_path) as ItemResource
	_initialize_the_real_item_with_its_properties(item_resource)


	
func _initialize_the_real_item_with_its_properties(item_resource: ItemResource):
	generate_both_collision_circles(item_resource)
	load_script_dinamically(item_resource)
	update_sprite2D_texture(item_resource)
"""
NOTE TO SELF AND OTHERS

Se crei un nodo dentro all'editor visuale, e vuoi modificargli delle proprietà, a meno che quel nodo non sia un singleton,
NON, e ripeto, NON crearlo visualmente dentro l'editor, devi NECESSARIAMENTE crearlo dinamicamente, altrimenti
per qualche motivo è un nodo solo per ogni istanza della classe in cui si trova.

Avevo messo "CollisionShape2D" dentro alla scena di generic_item.tscn,
e per tutti il radius restava uguale, perché per il primo generic_item1 modificava con un certo raggio,
e poi generic_item2 ricambiava il raggio dello stesso CollisionShape2D, quindi tutti avevano lo stesso identico raggio.
Non so bene come funzioni, ma se avete problemi di questo tipo, create dinamicamente l'albero dei nodi come ho
fatto qui sotto.

"""
func generate_both_collision_circles(item_resource: ItemResource):
	#Cambia il raggio del CollisionShape2D in base al raggio indicato
	var new_radius = item_resource.collision_circle_radius #Prendi quello dal .tres inizialmente
	if collision_circle_radius > 0: #Se è settato nelle variabili esportate, prendilo da li
		new_radius = collision_circle_radius
	
	var item_interaction_collision_circle_shape = CollisionShape2D.new()
	var circle_shape_item = CollisionShapeCreator.create_circle_shape(item_interaction_collision_circle_shape, new_radius)
	item_interaction.add_child(item_interaction_collision_circle_shape)
	
	var actual_collision_circle_shape = CollisionShape2D.new()
	var circle_shape_static = CollisionShapeCreator.create_circle_shape(actual_collision_circle_shape, new_radius)
	static_body_2D.add_child(actual_collision_circle_shape)

func load_script_dinamically(item_resource: ItemResource):
	#Carica e fai attach dinamico dello script che serve
	var script = load(item_resource.script_path)
	var script_instance = script.new()
	add_child(script_instance)


func update_sprite2D_texture(item_resource: ItemResource):
	#Carica l'immagine dell'oggetto
	var image_texture = load(item_resource.sprite_path)
	sprite2D.texture = image_texture
