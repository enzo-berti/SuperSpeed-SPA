extends Node2D

#Exported nodes
@export var path_follow : PathFollow2D
@export var area : Area2D
@export var collision_shape : CollisionShape2D

#Cucumber movement
var x : float = 0
var direction_reversed : bool = false
var is_stopped : bool = false

#Score variables
@export var score_distance_limit : float = 85.0
@export var score_ratio : float
var score : float




func _ready() -> void:
	collision_shape.shape.radius = score_distance_limit
	pass


func _process(delta: float) -> void:
	
	#Cucumber movement
	match is_stopped:
		false:
			_slide(delta)
		true:
			if area.get_overlapping_bodies().size() > 0:
				score = (score_distance_limit / area.global_position.distance_to(area.get_overlapping_bodies()[0].global_position)) * 100
				print(score)

	#Stop
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) && not is_stopped:
		is_stopped = true


###### CUSTOM FUNCTIONS ######

func _slide(delta: float) -> void:
	if not direction_reversed:
		x += delta
	elif direction_reversed:
		x -= delta
	
	if x > 1:
		x = 1
		direction_reversed = true
	if x < 0:
		x = 0
		direction_reversed = false
	
	path_follow.progress_ratio = ease.InOutSine(x)
