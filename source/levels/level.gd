extends Node2D

enum states { START, MASK, CUCUMBER, FINISH }
var state_machine : states

var is_there_client : bool = false
@onready var spawn_pos : Vector2 = $SpawnPoint.position


###### BUILT-IN FUNCTIONS ######

func _ready() -> void:
	spawn_client()
	
	state_machine = states.START
	pass

func _process(delta: float) -> void:
	if !is_there_client:
		spawn_client()
	pass


###### CUSTOM FUNCTIONS ######

#Spawn new client
func spawn_client() -> void:
	var client = preload("res://characters/duck/duck_client.tscn")
	var instance = client.instantiate()
	add_child(instance)
	instance.position = spawn_pos
	is_there_client = true
	
	instance.start_mask()
	pass
