class_name CollisionShapeCreator
extends Node

"""
Centralizza la creazione dei collisionshape e returnali
"""

static func create_rect_shape(father: CollisionShape2D, x: int, y: int):
	var rect_shape_container = RectangleShape2D.new()
	rect_shape_container.size.x = x
	rect_shape_container.size.y = y
	father.shape = rect_shape_container
	return rect_shape_container

static func create_circle_shape(father: CollisionShape2D, radius: int):
	var circle_shape_item = CircleShape2D.new()
	father.shape = circle_shape_item
	father.shape.radius = radius
	return circle_shape_item
