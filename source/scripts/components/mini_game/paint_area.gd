class_name PaintArea
extends Sprite2D

signal press_brush
signal release_brush

@export var brush_color : Color
@export var brush_size : int
var can_paint : bool = true

var _image : Image

func _input(event: InputEvent) -> void:
	_drawInput(event)

func _drawInput(event: InputEvent) -> void:
	if !can_paint || brush_color.a == 0:
		release_brush.emit()
		return
	
	if event is not InputEventMouseMotion || event.button_mask != MOUSE_BUTTON_LEFT:
		release_brush.emit()
		return
	
	if event.relative.length_squared() <= 0:
		release_brush.emit()
		return
	
	var lpos = to_local(event.position)
	var impos: Vector2 = lpos - offset + get_rect().size / 2.0
	if !get_rect().has_point(lpos - offset):
		return
	
	var num := ceili(event.relative.length())
	var target_pos = impos - (event.relative)
	
	for i in num:
		impos = impos.move_toward(target_pos, 1.0)
		filled_circle(_image, impos, brush_size)
	
	texture.update(_image)
	press_brush.emit()

func calcul_color_pourcentage(color_target: Color) -> float:
	var texture_size: Vector2 = texture.get_size()
	var score: int = 0
	
	for y in range(0, texture_size.y):
		for x in range(0, texture_size.x):
			if color_target == _image.get_pixel(x, y):
				score += 1
			
	return score / (texture_size.x * texture_size.y)

func defineTextureMask(maskTexture: Texture2D) -> void:
	_image = Image.create_empty(int(maskTexture.get_size().x), int(maskTexture.get_size().y), false, Image.FORMAT_RGBA8)
	texture = ImageTexture.create_from_image(_image)
	material.set("shader_parameter/mask_texture", maskTexture) 

func change_mask_color(new_color: MaskColorAssets.mask_color) -> void:
	brush_color = MaskColorAssets.get_mask_color(new_color)

func filled_circle(image_screen: Image, pos: Vector2i, radius: int)->void:
	for i in range(-radius, radius):
		var height: int = int(sqrt(radius * radius - i * i))
		for j in range(-height, height):
			if (get_rect().has_point(Vector2(i + pos.x, j + pos.y) + get_rect().position)):
				image_screen.set_pixel(i + pos.x, j + pos.y, brush_color)
