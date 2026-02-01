extends Node2D

enum states { START, MASK, CUCUMBER, FINISH }
var state_machine : states

var clients_resources : Array[Resource]

var is_there_client : bool = false
@onready var spawn_pos : Vector2 = $SpawnPoint.position
var rng = RandomNumberGenerator.new()

var actual_client : Node

@export var mask_menu_node : Node
@export var massage_menu_node : Node

@onready var main_menu : Control = $MainMenu
@onready var music_player : AudioStreamPlayer = $AudioStreamPlayer
@onready var music_1 = preload("res://mini_games/Main_theme_Chill_80BPM.ogg")
@onready var music_2 = preload("res://mini_games/Main_theme_Chill_100BPM.ogg")
@onready var music_3 = preload("res://mini_games/Main_Theme_Techno_120BPM.ogg")
@onready var music_4 = preload("res://mini_games/Main_Theme_Techno_140BPM.ogg")

var color_names : Array[String] = ["blue", "green", "yellow", "red", "violet", "pink"] 

###### BUILT-IN FUNCTIONS ######

func _ready() -> void:
	clients_resources = [preload("res://characters/cupcake/cupcake_client.tscn"), 
preload("res://characters/duck/duck_client.tscn"), 
preload("res://characters/flower/flower_client.tscn"), 
preload("res://characters/troll/troll_client.tscn"), 
preload("res://characters/wrestler/wrestler_client.tscn"),
preload("res://characters/racoon/racoon_client.tscn")]
	music_player.stream = music_1
	music_player.play()



func _process(delta: float) -> void:
	
	
	if !is_there_client:
		spawn_client()
		state_machine = states.START
	
	match state_machine:
		states.START:
			if !actual_client.is_in_animation():
				_start_mask_mini_game()
		states.MASK:
			if not actual_client.get_node("Mask/PaintArea").check_win():
				return
			
			game_manager.score += 30
			mask_menu_node.visible = false
			state_machine = states.CUCUMBER
			actual_client.start_cucumber()
		states.CUCUMBER:
			if not actual_client.get_node("CucumberGame").is_finished():
				return
			
			state_machine = states.FINISH
			game_manager.win_clients += 1
			game_manager.win_strike += 1
			actual_client.destroy()
			match game_manager.win_strike:
				0:
					music_player.stream = null
					music_player.stream = music_1
					music_player.play()
				1:
					music_player.stream = null
					music_player.stream = music_2
					music_player.play()
				2:
					music_player.stream = null
					music_player.stream = music_3
					music_player.play()
				3:
					music_player.stream = null
					music_player.stream = music_4
					music_player.play()
		states.FINISH:
			main_menu.stop_patience()
			if actual_client == null:
				is_there_client = false

###### CUSTOM FUNCTIONS ######
#Spawn new client
func spawn_client() -> void:
	var client = clients_resources[rng.randi_range(0, clients_resources.size() - 1)]
	actual_client = client.instantiate()
	add_child(actual_client)
	actual_client.position = spawn_pos
	is_there_client = true

func _start_mask_mini_game() -> void:
	state_machine = states.MASK
	actual_client.start_mask()
	mask_menu_node.set_mask_needed(color_names[rng.randi_range(0, color_names.size() - 1)])
	mask_menu_node.visible = true
	main_menu.start_patience()


func _on_main_menu_patience_timeout() -> void:
	state_machine = states.FINISH
	actual_client.destroy()
