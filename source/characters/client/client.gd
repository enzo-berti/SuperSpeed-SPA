extends CharacterBody2D

@onready var spawn_pos : Vector2 = get_node("../SpawnPoint").position
@onready var game_pos : Vector2 = get_node("../GamePoint").position
@onready var destroy_pos : Vector2 = get_node("../DestroyPoint").position
var destination : Vector2

@export var speed : float = 10
var x : float = 0

###### BUILT-IN FUNCTIONS ######

func _ready() -> void:
	destination = game_pos

func _physics_process(delta: float) -> void:
	x += delta / (10 / speed)
	
	if x > 1:
		x = 1
	
	if destination == game_pos:
		position = spawn_pos + ease.OutBounce(x) * (destination - spawn_pos)
	elif destination == destroy_pos:
		position = game_pos + ease.InSine(x) * (destination - game_pos)
	
	
	if position.distance_to(destroy_pos) < 10:
		queue_free()


###### CUSTOM FUNCTIONS ######

#Makes client leave the screen then be deleted
func destroy() -> void:
	destination = destroy_pos
	x = 0
