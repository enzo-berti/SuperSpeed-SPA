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

###### BUILT-IN FUNCTIONS ######

func _ready() -> void:
	clients_resources = [preload("res://characters/cupcake/cupcake_client.tscn"), 
preload("res://characters/duck/duck_client.tscn"), preload("res://characters/flower/flower_client.tscn"), 
preload("res://characters/troll/troll_client.tscn"), preload("res://characters/wrestler/wrestler_client.tscn")]

func _process(delta: float) -> void:
	if !is_there_client:
		spawn_client()
		state_machine = states.START
	
	match state_machine:
		states.START:
			if !actual_client.is_in_animation():
				state_machine = states.MASK
				actual_client.start_mask()
				mask_menu_node.visible = true
		states.MASK:
			if not actual_client.get_node("Mask/PaintArea").check_win():
				return
			
			mask_menu_node.visible = false
			state_machine = states.CUCUMBER
			actual_client.start_cucumber()
		states.CUCUMBER:
			if not actual_client.get_node("CucumberGame").is_finished():
				return
			
			state_machine = states.FINISH
			actual_client.destroy()
		states.FINISH:
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
	pass

func spawn_mask_mini_game() -> void:
	
	pass
