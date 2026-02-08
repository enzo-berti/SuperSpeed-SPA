extends Control

@export var mask_needed_node: TextureRect

@onready var blue: TextureButton = $MaskContainer/Blue
@onready var green: TextureButton = $MaskContainer/Green
@onready var yellow: TextureButton = $MaskContainer/Yellow
@onready var red: TextureButton = $MaskContainer/Red
@onready var violet: TextureButton = $MaskContainer/Violet
@onready var pink: TextureButton = $MaskContainer/Pink

var last_button_pressed: TextureButton = null

func _get_paint_node() -> Node:
	return get_node("../Client/Mask/PaintArea")

func reset_buttons() -> void:
	blue.set_pressed(false)
	green.set_pressed(false)
	yellow.set_pressed(false)
	red.set_pressed(false)
	violet.set_pressed(false)
	pink.set_pressed(false)

func _on_mask_button_pressed(button_mask: TextureButton, color: MaskColorAssets.mask_color) -> void:
	if (!button_mask):
		return
	elif (last_button_pressed == button_mask):
		_get_paint_node().change_mask_color(-1)
		reset_buttons()
		last_button_pressed = null
	elif (last_button_pressed != button_mask):
		reset_buttons()
		_get_paint_node().change_mask_color(color)
		last_button_pressed = button_mask
		button_mask.button_pressed = true

func set_mask_needed(color: MaskColorAssets.mask_color) -> void:
	reset_buttons()
	mask_needed_node.texture = MaskColorAssets.get_mask_texture(color)
	get_node("../Client/Mask/PaintArea").set_mask_needed(MaskColorAssets.get_mask_color(color))

func _on_blue_pressed() -> void:
	_on_mask_button_pressed(blue, MaskColorAssets.mask_color.BLUE)

func _on_green_pressed() -> void:
	_on_mask_button_pressed(green, MaskColorAssets.mask_color.GREEN)

func _on_yellow_pressed() -> void:
	_on_mask_button_pressed(yellow, MaskColorAssets.mask_color.YELLOW)

func _on_red_pressed() -> void:
	_on_mask_button_pressed(red, MaskColorAssets.mask_color.RED)

func _on_violet_pressed() -> void:
	_on_mask_button_pressed(violet, MaskColorAssets.mask_color.VIOLET)

func _on_pink_pressed() -> void:
	_on_mask_button_pressed(pink, MaskColorAssets.mask_color.PINK)
