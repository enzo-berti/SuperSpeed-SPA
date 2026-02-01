extends Control

@export var timer : Timer
@export var star_timer : Timer
@export var patience_time : float = 20.0
@export var patience_meter : TextureProgressBar

@export var score_label : Label

@onready var gameover = preload("res://levels/main_scene/UI/gameover_screen/gameover.tscn")

@onready var stars_array : Array[TextureProgressBar] = [$HeartContainer/Star1, $HeartContainer/Star2, $HeartContainer/Star3]

var is_client_angry : bool = false
var x : float

signal patience_timeout


###### BUILT-IN FUNCTIONS ######

func _ready() -> void:
	patience_meter.visible = false


func _process(delta: float) -> void:
	patience_meter.value = timer.time_left / clampf((patience_time - (5 * game_manager.win_clients)), 20, patience_time) * 100
	
	if game_manager.health <= 0:
		get_tree().change_scene_to_packed(gameover)
	
	score_label.text = str(game_manager.score)
	
	
	#if is_client_angry:
		#x = clampf(star_timer.time_left, 0.0, 1.0)
		#stars_array[game_manager.health].value = ease.OutBounce(x)
		#is_client_angry = false
	
	
	#if Input.is_action_just_pressed("ui_accept"):
		#start_patience()
	#if Input.is_action_just_pressed("MOUSE_BUTTON_LEFT"):
		#angry_client(5.0)


###### CUSTOM FUNCTIONS ######

func start_patience() -> void:
	timer.wait_time = patience_time - (5 * game_manager.win_clients)
	patience_meter.visible = true
	timer.start()

func stop_patience() -> void:
	patience_meter.visible = false
	timer.stop()

func angry_client(time_malus : int) -> void:
	var remaining_time : float = timer.time_left
	
	if remaining_time <= time_malus:
		timer.stop()
		timer.wait_time = 0.1
		timer.start()
		return
	
	timer.stop()
	timer.wait_time = remaining_time - time_malus
	timer.start()


###### SIGNAL FUNCTIONS ######

func _on_timer_timeout() -> void:
	game_manager.win_strike -= 1
	#is_client_angry = true
	#star_timer.start()
	game_manager.health -= 1
	stars_array[game_manager.health].value = 0.0
	patience_meter.visible = false
	timer.stop()
	patience_timeout.emit()
	stop_patience()
