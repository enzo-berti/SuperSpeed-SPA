extends Node

var mask_blue_texture : Texture2D = load("res://mini_games/mask/assets/images/blue_open.PNG")
var mask_green_texture : Texture2D = load("res://mini_games/mask/assets/images/green_open.PNG")
var mask_pink_texture : Texture2D = load("res://mini_games/mask/assets/images/pink_open.PNG")
var mask_red_texture : Texture2D = load("res://mini_games/mask/assets/images/red_open.PNG")
var mask_violet_texture : Texture2D = load("res://mini_games/mask/assets/images/violet_open.PNG")
var mask_yellow_texture : Texture2D = load("res://mini_games/mask/assets/images/yellow_open.png")

var blue : Color = Color.LIGHT_SKY_BLUE
var green : Color = Color.DARK_OLIVE_GREEN
var yellow : Color = Color("#FFD700")
var red : Color = Color.INDIAN_RED
var violet : Color = Color.DARK_VIOLET
var pink : Color = Color.PINK
var none : Color = Color.TRANSPARENT

enum mask_color
{
	BLUE,
	GREEN,
	YELLOW,
	RED,
	VIOLET,
	PINK,
}

func get_mask_color(color : mask_color) -> Color:
	match color:
		mask_color.BLUE:
			return blue
		mask_color.GREEN:
			return green
		mask_color.YELLOW:
			return yellow
		mask_color.RED:
			return red
		mask_color.VIOLET:
			return violet
		mask_color.PINK:
			return pink
		_:
			return none

func get_mask_texture(color : mask_color) -> Texture2D:
	match color:
		mask_color.BLUE:
			return mask_blue_texture
		mask_color.GREEN:
			return mask_green_texture
		mask_color.YELLOW:
			return mask_yellow_texture
		mask_color.RED:
			return mask_red_texture
		mask_color.VIOLET:
			return mask_violet_texture
		mask_color.PINK:
			return mask_pink_texture
		_:
			return null
