extends Node2D

var eye_turn : int = 0
@onready var eyes : Array[Node2D]

@onready var label : Label = $Label

var finish : bool = false
@export var missing_target_time_malus : float = 5.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	eyes.append_array(get_tree().get_nodes_in_group("eyes"))
	_spawn_cucumber()


###### CUSTOM FUNCTIONS ######

func _spawn_cucumber() -> void:
	var client = preload("res://mini_games/cucumber/cucumber.tscn")
	var instance = client.instantiate()
	add_child(instance)
	instance.position = eyes[eye_turn].position
	instance.find_child("Path2D").cucumber_stopped.connect(_on_cucumber_stopped)


###### SIGNAL FUNCTIONS ######

func _on_cucumber_stopped(target_missed) -> void:
	print(target_missed)
	if target_missed:
		_spawn_cucumber()
		$"../../MainMenu".angry_client(missing_target_time_malus)
		get_parent().angry()
	elif not target_missed && eyes.size() - 1 != eye_turn:
		eye_turn += 1
		_spawn_cucumber()
	else:
		finish = true
		
func is_finished() -> bool:
	return finish
