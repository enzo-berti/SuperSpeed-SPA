extends Node2D

@export var pourcentage_needed: float
@export var paint_area: PaintArea
@export var mask_texture: Texture2D
@onready var sfx_mask: AudioStreamPlayer2D = $"SfxMask"

var paint_needed : Color

func set_mask_needed(new_color_needed: Color) -> void:
	paint_needed = new_color_needed

func _ready() -> void:
	paint_area.defineTextureMask(mask_texture)

func has_finished_painting() -> bool:
	return paint_area.calcul_color_pourcentage(paint_needed) >= pourcentage_needed

func _end_mask_mini_game() -> void:
	paint_area.can_paint = false

func _on_paint_area_press_brush() -> void:
	if paint_needed != paint_area.brush_color:
		$"..".angry()

	if has_finished_painting():
		_end_mask_mini_game()
	
	if !sfx_mask.playing:
		sfx_mask.play()
	
	sfx_mask.stream_paused = false


func _on_paint_area_release_brush() -> void:
	sfx_mask.stream_paused = true
