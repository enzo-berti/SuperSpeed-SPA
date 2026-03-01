extends Node2D

const CLIENTS_RESOURCES : Array[Resource] = [preload("uid://cxk8ta827oaiv"), 
	preload("uid://dqn3khjuqij28"),
	preload("uid://dbo0pscce31q6"),
	preload("uid://dru53ao5tir82"),
	preload("uid://cctal0vvttmxc"),
	preload("uid://8bykminh816k")]

const MUSIC_1: Resource = preload("uid://dewnpj677wctp")
const MUSIC_2: Resource = preload("uid://cmy75ds3bux8y")
const MUSIC_3: Resource = preload("uid://c1cvdcmvskhm1")
const MUSIC_4: Resource = preload("uid://bjteqinkxqmed")

var is_there_client : bool = false
@onready var spawn_pos : Vector2 = $SpawnPoint.position
var rng = RandomNumberGenerator.new()

var actual_client : Node

@onready var ui_mask : Control = $UIMask
@onready var ui_massage : Control = $UIMassage
@onready var ui_game : Control = $UIGame
@onready var music_player : AudioStreamPlayer = $AudioStreamPlayer

var color_names : Array[String] = ["blue", "green", "yellow", "red", "violet", "pink"] 

###### BUILT-IN FUNCTIONS ######
func _ready() -> void:
	music_player.stream = MUSIC_1
	music_player.play()

func _process(_delta: float) -> void:
	if actual_client == null:
		is_there_client = false
	
	if !is_there_client:
		spawn_client()

###### CUSTOM FUNCTIONS ######
func spawn_client() -> void:
	var client = CLIENTS_RESOURCES[rng.randi_range(0, CLIENTS_RESOURCES.size() - 1)]
	actual_client = client.instantiate()
	actual_client.position = spawn_pos
	add_child(actual_client)
	actual_client.finished_game.connect(_on_client_finished_game)
	is_there_client = true

func _despawn_client() -> void:
	ui_game.stop_patience()
	actual_client.destroy()

func _on_client_finished_game(game_name: String) -> void:
	match game_name:
		"spawn":
			ui_mask.set_mask_needed(MaskColorAssets.mask_color.values().pick_random())
			ui_mask.visible = true
			ui_game.start_patience()
		"mask":
			ui_mask.visible = false
		"cucumber":
			GameManager.win_clients += 1
			GameManager.win_strike += 1
			
			_despawn_client()
			
			match GameManager.win_strike:
				0:
					music_player.stream = null
					music_player.stream = MUSIC_1
					music_player.play()
				1:
					music_player.stream = null
					music_player.stream = MUSIC_2
					music_player.play()
				2:
					music_player.stream = null
					music_player.stream = MUSIC_3
					music_player.play()
				3:
					music_player.stream = null
					music_player.stream = MUSIC_4
					music_player.play()
		_:
			print("ERROR : Undefined game name")
			pass

func _on_main_menu_patience_timeout() -> void:
	ui_mask.visible = false
	_despawn_client()
