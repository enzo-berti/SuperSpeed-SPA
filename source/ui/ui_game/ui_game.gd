extends Control

@export var patience_timer : Timer
@export var star_timer: Timer
@export var patience_time : float = 50.0
@export var patience_time_min : float = 20.0
@export var patience_meter : TextureProgressBar

@export var score_label : LabelScore

@onready var stars_array : Array[TextureProgressBar] = [$HeartContainer/Star1, $HeartContainer/Star2, $HeartContainer/Star3]

var x : float

signal patience_timeout


###### BUILT-IN FUNCTIONS ######

func _ready() -> void:
	patience_meter.visible = false

func _process(delta: float) -> void:
	patience_meter.value = patience_timer.time_left / patience_timer.wait_time
	
	if GameManager.health <= 0:
		get_tree().change_scene_to_packed(load(GameManager.GAME_OVER_SCENE_UID))
	
	score_label.text_desired = str(GameManager.score)
	
	if !star_timer.is_stopped():
		print(star_timer.time_left)
		stars_array[GameManager.health].value = star_timer.time_left / star_timer.wait_time


###### CUSTOM FUNCTIONS ######
func start_patience() -> void:
	var patience_time_desired: float = patience_time - (5 * GameManager.win_clients)
	patience_time = max(patience_time_desired, patience_time_min)
	
	patience_timer.wait_time = patience_time
	patience_meter.visible = true
	patience_timer.start()

func stop_patience() -> void:
	patience_meter.visible = false
	patience_timer.stop()

func angry_client(time_malus : int) -> void:
	var remaining_time : float = patience_timer.time_left
	
	if remaining_time <= time_malus:
		patience_timer.stop()
		patience_timer.wait_time = 0.1
		patience_timer.start()
		return
	
	patience_timer.stop()
	patience_timer.wait_time = remaining_time - time_malus
	patience_timer.start()


###### SIGNAL FUNCTIONS ######

func _on_timer_timeout() -> void:
	GameManager.win_strike -= 1
	GameManager.health -= 1
	
	star_timer.start()
	patience_meter.visible = false
	patience_timer.stop()
	patience_timeout.emit()
	stop_patience()
