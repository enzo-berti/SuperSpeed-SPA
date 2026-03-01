@tool
class_name Body2D
extends Node2D

@export var shape: Shape2D:
	set(new_value):
		if shape == new_value:
			return
		
		if shape != null and shape.changed.is_connected(queue_redraw):
			shape.changed.disconnect(queue_redraw)
		
		shape = new_value
		if shape != null and not shape.changed.is_connected(queue_redraw):
			shape.changed.connect(queue_redraw)
		
		queue_redraw()

@export var debug_color: Color:
	set(new_value):
		if debug_color == new_value:
			return
		
		debug_color = new_value
		if shape != null and not shape.changed.is_connected(queue_redraw):
			shape.changed.connect(queue_redraw)
		
		queue_redraw()

func _draw() -> void:
	if not Engine.is_editor_hint():
		return
	
	if shape == null:
		return
	
	shape.draw(get_canvas_item(), debug_color)
