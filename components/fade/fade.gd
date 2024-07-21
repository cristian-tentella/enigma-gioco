class_name Fade
extends Control


const TRANSPARENT_COLOR_HEX = 0x00000000
const BLACK_COLOR_HEX = 0x201e1dff
const WHITE_COLOR_HEX = 0xd4d0cfff
var TRANSPARENT = Color.hex(TRANSPARENT_COLOR_HEX)
var BLACK = Color.hex(BLACK_COLOR_HEX)
var WHITE = Color.hex(WHITE_COLOR_HEX)

@onready var background = $Background

@export var fade_duration_in_seconds = 0.15
var has_faded_in = false


func fade_in(background_color: Color = BLACK):
	if not self.visible:
		self.show()

	if self.has_faded_in:
		return

	create_tween().tween_property(
		self.background,
		"color",
		background_color,
		self.fade_duration_in_seconds,
	).set_ease(Tween.EASE_IN)

	self.has_faded_in = true


func fade_out():
	if not self.has_faded_in:
		return

	create_tween().tween_property(
		self.background,
		"color",
		self.TRANSPARENT,
		self.fade_duration_in_seconds,
	).set_ease(Tween.EASE_OUT)

	self.has_faded_in = false

	self.hide()
