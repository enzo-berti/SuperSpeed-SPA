extends Node2D

var is_there_client : bool = false


###### BUILT-IN FUNCTIONS ######

func _ready() -> void:
    spawn_client()
    pass

func _process(delta: float) -> void:
    if !is_there_client:
        spawn_client()
    pass


###### CUSTOM FUNCTIONS ######

#Spawn new client
func spawn_client() -> void:
    var client = preload("res://characters/client/client.tscn")
    var instance = client.instantiate()
    add_child(instance)
    is_there_client = true
    pass
