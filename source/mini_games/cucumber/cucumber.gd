extends Node2D

#Nodes
@onready var eye_pos : Vector2 = position
@onready var cucumber_pos : Vector2 = $PathFollow2D.position
@onready var path_follow : PathFollow2D = $PathFollow2D
@onready var sprite : Sprite2D = $"../Sprite2D"
@onready var sfx_cucumber: AudioStreamPlayer2D = $"../sfx_cucumber"

@onready var debug_score_distance_limit : CollisionShape2D = $PathFollow2D/DebugScoreDistanceLimit
@onready var debug_score_distance_deadzone : CollisionShape2D = $PathFollow2D/DebugScoreDistanceDeadzone
@onready var debug_state : Label = $"../DebugState"

#State machine
var states : Array[String] = ["move","clicked", "stopped"]
var state_machine : String = states[0]

#Cucumber movement
var x : float = 0
var direction_reversed : bool = false

#Score variables
@onready var score_distance_limit : float = debug_score_distance_limit.shape.radius
@onready var score_distance_dead_zone : float = debug_score_distance_deadzone.shape.radius
@export var score_max : int = 25

signal cucumber_stopped(target_misses : bool)


###### BUILT-IN FUNCTIONS ######


func _process(delta: float) -> void:
	cucumber_pos = $PathFollow2D.position
	
	print(cucumber_pos, " + ", eye_pos)
	
	#Cucumber movement
	match state_machine:
		"move":
			_slide(delta)
			if Input.is_action_just_pressed("MOUSE_BUTTON_LEFT"):
				state_machine = states[1]
				_score()
		"clicked":
			
			if Input.is_action_just_released("MOUSE_BUTTON_LEFT"):
				state_machine = states[2]
				
		"stopped":
			queue_free()
		
	debug_state.text = state_machine


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
	sprite.position = cucumber_pos

func _score() -> void:
	var score : int = int(score_max * (1 - clamp(cucumber_pos.distance_to(eye_pos) - score_distance_dead_zone, 0.0, score_distance_limit) / score_distance_limit))
	game_manager.score += score
	sfx_cucumber.play()
	
	if score == 0:
		cucumber_stopped.emit(true)
	if score > 0:
		cucumber_stopped.emit(false)
