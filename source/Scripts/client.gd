extends CharacterBody2D

@onready var first_pos : Vector2 = get_node("../FirstPos").position
@onready var leaving_pos : Vector2 = get_node("../LeavingPos").position

@export var speed : float = 10


###### BUILT-IN FUNCTIONS ######

func _ready() -> void:
	print(first_pos)
	pass

func _process(delta: float) -> void:
	pass


###### CUSTOM FUNCTIONS ######

func _slide(pos: Vector2) -> void:
	if position.distance_to(pos) > 0:
		velocity = Vector2.DOWN * 10
	move_and_slide()
	pass
