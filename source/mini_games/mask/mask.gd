extends Sprite2D

@export var paint_color : Color
@export var brush_size : int 
var img : Image

func defineTextureMask(textureMask : Texture2D) -> void:
	img = Image.create_empty(textureMask.get_size().x, textureMask.get_size().y, false, Image.FORMAT_RGBA8)
	img.fill(Color(0, 0, 0, 0)) # je sais pas si j'en ai besoin, mais je le fais
	texture = ImageTexture.create_from_image(img)
	material.set("shader_parameter/mask_texture", textureMask) 

func calcul_mask_pourcentage() -> float:
	var alpha_target = 0
	var texture_size := texture.get_size()
	var image := texture.get_image()
	var score = 0
	for y in range(0, texture_size.y):
		for x in range(0, texture_size.x):
			if alpha_target != image.get_pixel(x, y).a:
				score += 1
				
	return score / (texture.get_size().x * texture.get_size().y)

func _ready() -> void:
	pass

func _input(event: InputEvent) -> void:
	_drawInput(event)

func _paint_tex(pos: Vector2i) -> void:
	img.fill_rect(Rect2i(pos, Vector2i(1, 1)).grow(brush_size), paint_color)

func _drawInput(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if event.button_mask == MOUSE_BUTTON_LEFT:
			var lpos = to_local(event.position)
			var impos = lpos - offset + get_rect().size/2.0

			if event.relative.length_squared() > 0:
				var num := ceili(event.relative.length())
				var target_pos = impos - (event.relative)
				for i in num:
					impos = impos.move_toward(target_pos, 1.0)
					_paint_tex(impos)

			texture.update(img)
			print(calcul_mask_pourcentage())
