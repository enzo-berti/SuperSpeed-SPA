extends Node

const BLUE_TEXTURE = preload("uid://dqrya6m7x5xff")
const GREEN_TEXTURE = preload("uid://fisafk27k3h1")
const PINK_TEXTURE = preload("uid://bamf4eulufm36")
const RED_TEXTURE = preload("uid://5a7xnraiaex8")
const VIOLET_TEXTURE = preload("uid://bj1ysgddyuf53")
const YELLOW_TEXTURE = preload("uid://crn5iym1av4ja")

const BLUE_COLOR : Color = Color.LIGHT_SKY_BLUE
const GREEN_COLOR : Color = Color.DARK_OLIVE_GREEN
const YELLOW_COLOR : Color = Color("#FFD700")
const RED_COLOR : Color = Color.INDIAN_RED
const VIOLET_COLOR : Color = Color.DARK_VIOLET
const PINK_COLOR : Color = Color.PINK
const NONE_COLOR : Color = Color.TRANSPARENT

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
			return BLUE_COLOR
		mask_color.GREEN:
			return GREEN_COLOR
		mask_color.YELLOW:
			return YELLOW_COLOR
		mask_color.RED:
			return RED_COLOR
		mask_color.VIOLET:
			return VIOLET_COLOR
		mask_color.PINK:
			return PINK_COLOR
		_:
			return NONE_COLOR

func get_mask_texture(color : mask_color) -> Texture2D:
	match color:
		mask_color.BLUE:
			return BLUE_TEXTURE
		mask_color.GREEN:
			return GREEN_TEXTURE
		mask_color.YELLOW:
			return YELLOW_TEXTURE
		mask_color.RED:
			return RED_TEXTURE
		mask_color.VIOLET:
			return VIOLET_TEXTURE
		mask_color.PINK:
			return PINK_TEXTURE
		_:
			return null
