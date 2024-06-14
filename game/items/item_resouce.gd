# ItemResource.gd
extends Resource
class_name ItemResource

"""
Queste sono le variabili che sono definite in ogni file .tres relativo a uno specifico item.
Crea il file .tres dentro l'editor Godot, poi modificalo con un editor esterno.

Non serve nessuno scheletro. Se hai creato il file come da tutorial di generic_item.gd, è tutto già prefatto!
Questo è un esempio di come dovrebbe essere:
	
[gd_resource type="Resource" script_class="ItemResource" load_steps=2 format=3 uid="uid://dbtewnplahjhx"] - AUTOGENERATO

[ext_resource type="Script" path="res://game/items/item_resouce.gd" id="1_pds8t"] - AUTOGENERATO

[resource]
script = ExtResource("1_pds8t") - AUTOGENERATO
item_name = "mazzo_di_chiavi" - L'item name è NECESSARIAMENTE lo stesso con cui hai chiamato la folder
description = "Mazzo composto da 8 chiavi numerate" - La descrizione che faremo vedere nell'inventario
sprite_path = "res://game/items/mazzo_di_chiavi/mazzo_di_chiavi.png" - Prendila col right click sul file .png e fai "copia il percorso"
script_path = "res://game/items/mazzo_di_chiavi/mazzo_di_chiavi.gd" - Prendila col right click sul file .gd e fai "copia il percorso"
collision_circle_radius = 16 - Dipende dalla grandezza della pixel art, se in dubbio, metti 16
properties = {} - Finora non è usato, we will see
"""

@export var item_name: String #L'item name è NECESSARIAMENTE lo stesso con cui hai chiamato la folder
@export var description: String #La descrizione che faremo vedere nell'inventario
@export var sprite_path: String  # Path to the sprite for this item
@export var script_path: String  # Path to the script for this item
@export var collision_circle_radius: int # Grandezza della collisione, se non sei sicuro, metti 16
@export var properties: Dictionary  # Proprietà varie, per ora inutilizzato. Potrebbe essere un posto per mettere proprietà custom di un oggetto, non in comune con gli altri
