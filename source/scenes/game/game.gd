extends Node2D

enum states { START, MASK, CUCUMBER, FINISH }
var state_machine : states

const CLIENTS_RESOURCES : Array[Resource] = [preload("res://characters/cupcake/cupcake_client.tscn"), 
	preload("res://characters/duck/duck_client.tscn"), 
	preload("res://characters/flower/flower_client.tscn"), 
	preload("res://characters/troll/troll_client.tscn"), 
	preload("res://characters/wrestler/wrestler_client.tscn"),
	preload("res://characters/racoon/racoon_client.tscn")]

const MUSIC_1 = preload("res://mini_games/shared_assets/bgm/bgm_chill_80bpm.ogg")
const MUSIC_2 = preload("res://mini_games/shared_assets/bgm/bgm_chill_100bpm.ogg")
const MUSIC_3 = preload("res://mini_games/shared_assets/bgm/bgm_techno_120bpm.ogg")
const MUSIC_4 = preload("res://mini_games/shared_assets/bgm/bgm_techno_140bpm.ogg")

var is_there_client : bool = false
@onready var spawn_pos : Vector2 = $SpawnPoint.position
var rng = RandomNumberGenerator.new()

var actual_client : Node

@export var mask_menu_node : Node
@export var massage_menu_node : Node

@onready var main_menu : Control = $UIGame
@onready var music_player : AudioStreamPlayer = $AudioStreamPlayer

var color_names : Array[String] = ["blue", "green", "yellow", "red", "violet", "pink"] 

###### BUILT-IN FUNCTIONS ######

func _ready() -> void:
	music_player.stream = MUSIC_1
	music_player.play()

func _process(_delta: float) -> void:
	if !is_there_client:
		spawn_client()
		state_machine = states.START
	
	match state_machine:
		states.START:
			if !actual_client.is_in_animation():
				_start_mask_mini_game()
		states.MASK:
			if !actual_client.get_node("Mask/PaintArea").check_win():
				return
			
			_end_mask_mini_game()
			GameManager.score += 30
			_start_cucumber_mini_game()
		states.CUCUMBER:
			if !actual_client.get_node("CucumberGame").is_finished():
				return
			
			_end_cucumber_mini_game()
			_on_client_win() # doesn't have any state after cucumber
		states.FINISH:
			main_menu.stop_patience()
			if actual_client == null:
				is_there_client = false

###### CUSTOM FUNCTIONS ######
#Spawn new client
func spawn_client() -> void:
	var client = CLIENTS_RESOURCES[rng.randi_range(0, CLIENTS_RESOURCES.size() - 1)]
	actual_client = client.instantiate()
	add_child(actual_client)
	actual_client.position = spawn_pos
	is_there_client = true

func _despawn_client() -> void:
	state_machine = states.FINISH
	actual_client.destroy()

func _start_mask_mini_game() -> void:
	state_machine = states.MASK
	actual_client.start_mask()
	mask_menu_node.set_mask_needed(MaskColorAssets.mask_color.values().pick_random())
	mask_menu_node.visible = true
	main_menu.start_patience()

func _end_mask_mini_game() -> void:
	actual_client.get_node("Mask/PaintArea").can_paint = false
	mask_menu_node.visible = false

func _start_cucumber_mini_game() -> void:
	state_machine = states.CUCUMBER
	actual_client.start_cucumber()

func _end_cucumber_mini_game() -> void:
	pass

func _on_client_win() -> void:
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

func _on_main_menu_patience_timeout() -> void:
	_end_mask_mini_game()
	_end_cucumber_mini_game()
	_despawn_client()
