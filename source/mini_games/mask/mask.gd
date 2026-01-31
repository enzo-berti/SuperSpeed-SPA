extends Sprite2D

@export var paint_color : Color
@export var brush_size : float 
var img : Image

func _ready() -> void:
	img = Image.create_empty(256, 256, false, Image.FORMAT_RGBA8)
	img.fill(Color(0, 0, 0, 0))
	texture = ImageTexture.create_from_image(img)

func _paint_tex(pos) -> void:
	img.fill_rect(Rect2i(pos, Vector2i(1, 1)).grow(brush_size / 2.0), paint_color)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.is_echo() == false:
			if event.button_index == MOUSE_BUTTON_LEFT:
				var lpos = to_local(event.position)
				var impos = lpos - offset + get_rect().size / 2.0
			
				_paint_tex(impos)
				texture.update(img)
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
			var target_color = Color(0, 0, 0, 0)
			var color := Vector3.ZERO
			var texture_size := texture.get_size()
			var image := texture.get_image()
	
			var score = 0
			for y in range(0, texture_size.y):
				for x in range(0, texture_size.x):
					if target_color.a == image.get_pixel(x, y).a:
						score += 1
				
			score /= texture_size.x * texture_size.y
	
			print(score)
			
