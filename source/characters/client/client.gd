extends CharacterBody2D

@onready var first_pos : Vector2 = get_node("../FirstPos").position
@onready var leaving_pos : Vector2 = get_node("../LeavingPos").position
var destination : Vector2

@export var speed : float = 10

var is_leaving : bool = false


###### BUILT-IN FUNCTIONS ######

func _ready() -> void:
	destination = first_pos

func _physics_process(delta: float) -> void:
	#Move the client
	velocity = position.direction_to(destination) * (speed *10)
	
	#Avoid weird move when reaching destination
	if position.distance_to(destination) > 10:
		move_and_slide()
	#Check if client is out of the screen to delete it
	elif position.distance_to(destination) < 10 && is_leaving:
		queue_free()


###### CUSTOM FUNCTIONS ######

#Makes client leave the screen then be deleted
func exit() -> void:
	is_leaving = true
	destination = leaving_pos
	pass
