class_name PaintArea
extends Sprite2D

var can_paint : bool = true
var paint_needed : Color
var paint_image : Image
@export var paint_color : Color
@export var brush_size : int

@onready var sfx_mask: AudioStreamPlayer2D = $"../SfxMask"

func defineTextureMask(textureMask: Texture2D) -> void:
	@warning_ignore("narrowing_conversion")
	paint_image = Image.create_empty(textureMask.get_size().x, textureMask.get_size().y, false, Image.FORMAT_RGBA8)
	paint_image.fill(Color(0, 0, 0, 0))
	texture = ImageTexture.create_from_image(paint_image)
	material.set("shader_parameter/mask_texture", textureMask) 

func change_mask_color(new_color: MaskColorAssets.mask_color) -> void:
	paint_color = MaskColorAssets.get_mask_color(new_color)

func set_mask_needed(new_color_needed: Color) -> void:
	paint_needed = new_color_needed

func calcul_mask_pourcentage() -> float:
	var color_target: Color = paint_needed
	var texture_size: Vector2 = texture.get_size()
	var score: int = 0
	
	for y in range(0, texture_size.y):
		for x in range(0, texture_size.x):
			if color_target == paint_image.get_pixel(x, y):
				score += 1
			
	return score / (texture_size.x * texture_size.y)

func _input(event: InputEvent) -> void:
	_drawInput(event)

func filled_circle(image_screen: Image, pos: Vector2i, radius: int)->void:
	for i in range(-radius, radius):
		var height: int = int(sqrt(radius * radius - i * i))
		for j in range(-height, height):
			if (get_rect().has_point(Vector2(i + pos.x, j + pos.y) + get_rect().position)):
				image_screen.set_pixel(i + pos.x, j + pos.y, paint_color)

func _drawInput(event: InputEvent) -> void:
	if !can_paint || paint_color.a == 0:
		sfx_mask.stream_paused = true
		return
	
	if event is not InputEventMouseMotion:
		sfx_mask.stream_paused = true
		return

	if event.button_mask != MOUSE_BUTTON_LEFT:
		sfx_mask.stream_paused = true
		return
		
	if event.relative.length_squared() > 0:
		var lpos = to_local(event.position)
		var impos: Vector2 = lpos - offset + get_rect().size / 2.0
		
		if !get_rect().has_point(lpos - offset):
			return
		
		sfx_mask.stream_paused = false
		
		var num := ceili(event.relative.length())
		var target_pos = impos - (event.relative)
		
		for i in num:
			impos = impos.move_toward(target_pos, 1.0)
			filled_circle(paint_image, impos, brush_size)
		
		if paint_needed != paint_color:
			$"../..".angry()
		
	texture.update(paint_image)
