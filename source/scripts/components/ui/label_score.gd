class_name LabelScore
extends Label

@export var text_speed: float = 0.005
var text_timer: float = 0

var text_desired: String = "0"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (text_desired == text):
		return
	
	text_timer += delta
	if (text_timer < text_speed):
		return
	
	var step: int = text_timer / text_speed
	text_timer -= text_speed * step
	text = str(clampi(text.to_int() + step, 0, text_desired.to_int()))
