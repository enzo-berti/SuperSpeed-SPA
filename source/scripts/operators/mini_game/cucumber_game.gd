class_name CucumberGame
extends Node2D

@onready var eyes: Array[Node2D]

const CUCUMBER_RESOURCE: Resource = preload("uid://bjar0nsv8motn")

var eye_turn: int = 0
var finish: bool = false

func _ready() -> void:
	eyes.append_array(get_tree().get_nodes_in_group("eyes"))

###### CUSTOM FUNCTIONS ######
func spawn_cucumber() -> void:
	var cucumber_instance = CUCUMBER_RESOURCE.instantiate()
	cucumber_instance.position = eyes[eye_turn].position
	add_child(cucumber_instance)
	cucumber_instance.cucumber_stopped.connect(_on_cucumber_stopped)

###### SIGNAL FUNCTIONS ######
func _on_cucumber_stopped(target_missed) -> void:
	if target_missed:
		spawn_cucumber()
		get_parent().angry()
	elif not target_missed && eyes.size() - 1 != eye_turn:
		eye_turn += 1
		spawn_cucumber()
	else:
		finish = true

func is_finished() -> bool:
	return finish
