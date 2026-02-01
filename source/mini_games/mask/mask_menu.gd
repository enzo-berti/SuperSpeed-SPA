extends Control

@export var mask_blue_texture : Texture2D
@export var mask_green_texture : Texture2D
@export var mask_yellow_texture : Texture2D
@export var mask_red_texture : Texture2D
@export var mask_violet_texture : Texture2D
@export var mask_pink_texture : Texture2D

func _on_blue_pressed() -> void:
	set_mask_needed("green")
	get_node("../Client/Mask/PaintArea").change_mask_color(Color.LIGHT_SKY_BLUE)

func _on_green_pressed() -> void:
	get_node("../Client/Mask/PaintArea").change_mask_color(Color.DARK_OLIVE_GREEN)

func _on_yellow_pressed() -> void:
	get_node("../Client/Mask/PaintArea").change_mask_color(Color.YELLOW)

func _on_red_pressed() -> void:
	get_node("../Client/Mask/PaintArea").change_mask_color(Color.INDIAN_RED)

func _on_violet_pressed() -> void:
	get_node("../Client/Mask/PaintArea").change_mask_color(Color.BLUE_VIOLET)

func _on_pink_pressed() -> void:
	get_node("../Client/Mask/PaintArea").change_mask_color(Color.PINK)

func set_mask_needed(color: String) -> void:
	if color == "blue":
		get_node("TextBubble/MaskNeeded").texture = mask_blue_texture
		get_node("../Client/Mask/PaintArea").set_mask_needed(Color.LIGHT_SKY_BLUE)
	elif color == "green":
		get_node("TextBubble/MaskNeeded").texture = mask_green_texture
		get_node("../Client/Mask/PaintArea").set_mask_needed(Color.DARK_OLIVE_GREEN)
	elif color == "yellow":
		get_node("TextBubble/MaskNeeded").texture = mask_yellow_texture
		get_node("../Client/Mask/PaintArea").set_mask_needed(Color.YELLOW)
	elif color == "red":
		get_node("TextBubble/MaskNeeded").texture = mask_red_texture
		get_node("../Client/Mask/PaintArea").set_mask_needed(Color.INDIAN_RED)
	elif color == "violet":
		get_node("TextBubble/MaskNeeded").texture = mask_violet_texture
		get_node("../Client/Mask/PaintArea").set_mask_needed(Color.BLUE_VIOLET)
	elif color == "pink":
		get_node("TextBubble/MaskNeeded").texture = mask_pink_texture
		get_node("../Client/Mask/PaintArea").set_mask_needed(Color.PINK)
