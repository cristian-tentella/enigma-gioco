extends Node2D


func print_node_tree():
	print_debug(self.get_tree().root.get_tree_string_pretty())
