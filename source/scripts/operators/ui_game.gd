extends Control

@export var patience_timer : Timer
@export var star_timer: Timer
@export var patience_meter : TextureProgressBar

@export var score_label : LabelScore

@onready var stars_array : Array[TextureProgressBar] = [$HeartContainer/Star1, $HeartContainer/Star2, $HeartContainer/Star3]

var x : float

signal patience_timeout


###### BUILT-IN FUNCTIONS ######

func _ready() -> void:
	patience_meter.visible = false

func _process(delta: float) -> void:
	_process_patience(delta)
	_process_score()
	_process_health()
	
	score_label.text_desired = str(GameManager.score)

func _process_patience(delta: float) -> void:
	if (patience_timer.is_stopped()):
		return
	
	patience_meter.value = max(patience_meter.value - delta, patience_timer.time_left / GameManager.patience_time)
	# make the tint red because the texture is orange (orange - blue = red)
	patience_meter.tint_progress = Color(1, Ease.OutQuart(patience_meter.value / patience_meter.max_value), 1)

func _process_score() -> void:
	score_label.text_desired = str(GameManager.score)

func _process_health() -> void:
	if !star_timer.is_stopped():
		stars_array[GameManager.health].value = star_timer.time_left / star_timer.wait_time
	
	if GameManager.health <= 0:
		get_tree().change_scene_to_packed(load(GameManager.GAME_OVER_SCENE_UID))

###### CUSTOM FUNCTIONS ######
func start_patience() -> void:
	GameManager.patience_time_update()
	
	patience_timer.wait_time = GameManager.patience_time
	patience_meter.visible = true
	patience_timer.start()

func stop_patience() -> void:
	patience_meter.visible = false
	patience_timer.stop()

func angry_client(time_malus : float) -> void:
	patience_timer.start(patience_timer.time_left / 2.0)


###### SIGNAL FUNCTIONS ######

func _on_timer_timeout() -> void:
	GameManager.win_strike -= 1
	GameManager.health -= 1
	
	star_timer.start()
	patience_meter.visible = false
	patience_timer.stop()
	patience_timeout.emit()
	stop_patience()
