extends Node2D

@export var pourcentage_needed: float
@export var paint_area: PaintArea
@export var mask_texture: Texture2D

func _ready() -> void:
	paint_area.defineTextureMask(mask_texture)

func _process(_delta: float) -> void:
	if !has_finished_painting():
		return
			
	_end_mask_mini_game()

func has_finished_painting() -> bool:
	return paint_area.calcul_mask_pourcentage() >= pourcentage_needed

func _end_mask_mini_game() -> void:
	paint_area.can_paint = false
