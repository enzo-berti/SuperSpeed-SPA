class_name MoveTo
extends Node2D

enum Method {
	LINEAR,
	OUT,
	IN
}

enum State {
	MOVING,
	STOPPED
}

@export var destination: Vector2 = Vector2.ZERO
@export var speed: float = 1.0
@export var method: Method = Method.LINEAR
@export var state: State = State.STOPPED

var _progress: float = 0.0
var _initial_pos: Vector2 = Vector2.ZERO

signal started
signal ended

func start(to: Vector2, movement: Method = Method.LINEAR) -> void:
	_initial_pos = get_parent().position
	destination = to
	method = movement
	
	state = State.MOVING
	_progress = 0
	
	started.emit()

func stop() -> void:
	state = State.STOPPED
	destination = Vector2.ZERO
	_progress = 0
	
	ended.emit()

func process_movement(delta: float) -> Vector2:
	var new_pos: Vector2 = Vector2.ZERO
	_progress += clamp(delta * speed, 0.0, 1.0)
	
	match method:
		Method.LINEAR:
			pass
		Method.OUT:
			new_pos = _initial_pos + Ease.OutBounce(_progress) * (destination - _initial_pos)
		Method.IN:
			new_pos = _initial_pos + Ease.InSine(_progress) * (destination - _initial_pos)
		
	if _progress >= 1:
		stop()
	
	return new_pos
