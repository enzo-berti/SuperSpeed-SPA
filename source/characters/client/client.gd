extends Node2D

@export var mask_texture : Texture2D

@onready var spawn_pos : Vector2 = get_node("../SpawnPoint").position
@onready var game_pos : Vector2 = get_node("../GamePoint").position
@onready var destroy_pos : Vector2 = get_node("../DestroyPoint").position
var destination : Vector2

var mask_prefab : Resource
var cucumber_prefab : Resource

@export var speed : float = 10
var x : float = 0

var in_animation : bool = true
@onready var timer: Timer = $Timer
var is_angry : bool = false


###### BUILT-IN FUNCTIONS ######

func _ready() -> void:
	destination = game_pos
	
	mask_prefab = preload("res://mini_games/mask/mask.tscn")
	cucumber_prefab = preload("res://mini_games/cucumber/cucumber_game.tscn")

func is_in_animation() -> bool:
	return in_animation

func _physics_process(delta: float) -> void:
	# timer for start animation
	x += clamp(delta / (10 / speed), 0, 1)
	
	if destination == game_pos:
		position = spawn_pos + ease.OutBounce(x) * (destination - spawn_pos)
		in_animation = true
	elif destination == destroy_pos:
		position = game_pos + ease.InSine(x) * (destination - game_pos)
		in_animation = true
	else:
		in_animation = false
		
	if x >= 1:
		destination = Vector2.ZERO
		x = 0
		
	if position.distance_to(destroy_pos) <= 10:
		queue_free()


###### CUSTOM FUNCTIONS ######

#Makes client leave the screen then be deleted
func destroy() -> void:
	destination = destroy_pos
	x = 0
	
func start_mask() -> void:
	var instance = mask_prefab.instantiate()
	instance.get_node("PaintArea").defineTextureMask(mask_texture)
	add_child(instance)
	
func start_cucumber() -> void:
	var instance = cucumber_prefab.instantiate()
	add_child(instance)

func idle() -> void:
	$AnimatedSprite2D.play("idle")

func angry() -> void:
	$AnimatedSprite2D.play("angry")
	if not is_angry:
		$"../MainMenu".angry_client(2.0)
	timer.start()
	is_angry = true

func happy() -> void:
	$AnimatedSprite2D.play("happy")


func _on_timer_timeout() -> void:
	is_angry = false
	idle()
