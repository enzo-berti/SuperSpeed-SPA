extends Node2D

@export var mask: Node2D
@export var cucumber: Node2D

@onready var spawn_pos: Vector2 = get_node("../SpawnPoint").position
@onready var game_pos: Vector2 = get_node("../GamePoint").position
@onready var destroy_pos: Vector2 = get_node("../DestroyPoint").position
var destination: Vector2

@export var speed: float = 10
var x: float = 0

var in_animation: bool = true
@onready var angry_timer: Timer = $AngryTimer
var is_angry: bool = false


func _ready() -> void:
	destination = game_pos

func _physics_process(delta: float) -> void:
	# timer for start animation
	x += clamp(delta / (10 / speed), 0, 1)
	
	if destination == game_pos:
		position = spawn_pos + Ease.OutBounce(x) * (destination - spawn_pos)
		in_animation = true
	elif destination == destroy_pos:
		position = game_pos + Ease.InSine(x) * (destination - game_pos)
		in_animation = true
	else:
		in_animation = false
		
	if x >= 1:
		destination = Vector2.ZERO
		x = 0
		
	if position.distance_to(destroy_pos) <= 10:
		queue_free()

func _on_timer_timeout() -> void:
	is_angry = false
	idle()


func is_in_animation() -> bool:
	return in_animation

#Makes client leave the screen then be deleted
func destroy() -> void:
	destination = destroy_pos
	x = 0

func start_mask() -> void:
	mask.process_mode = PROCESS_MODE_INHERIT
	
func start_cucumber() -> void:
	cucumber.process_mode = PROCESS_MODE_INHERIT
	cucumber.spawn_cucumber()

func idle() -> void:
	$AnimatedSprite2D.play("idle")

func angry() -> void:
	$AnimatedSprite2D.play("angry")
	if not is_angry:
		$"../UIGame".angry_client(2.0)
	angry_timer.start()
	is_angry = true

func happy() -> void:
	$AnimatedSprite2D.play("happy")
