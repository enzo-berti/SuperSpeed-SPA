extends Node2D

@onready var mask: MaskGame = %Mask
@onready var cucumber: Node2D = %CucumberGame
@onready var move_to: MoveTo = %MoveTo

@onready var spawn_pos: Vector2 = get_node("../SpawnPoint").position
@onready var game_pos: Vector2 = get_node("../GamePoint").position
@onready var destroy_pos: Vector2 = get_node("../DestroyPoint").position

var in_animation: bool = true
@onready var angry_timer: Timer = $AngryTimer
var is_angry: bool = false

@onready var sfx_new_client: AudioStreamPlayer2D = $SFXNewClient
@onready var sfx_neutral: AudioStreamPlayer2D = $SFXNeutral
@onready var sfx_happy: AudioStreamPlayer2D = $SFXHappy
@onready var sfx_angry: AudioStreamPlayer2D = $SFXAngry

func _ready() -> void:
	move_to.start(game_pos, MoveTo.Method.OUT)
	sfx_new_client.play()

func _physics_process(delta: float) -> void:
	if move_to.state == MoveTo.State.MOVING:
		position = move_to.process_movement(delta)

func _on_timer_timeout() -> void:
	is_angry = false
	idle()

func is_in_animation() -> bool:
	return in_animation

#Makes client leave the screen then be deleted
func destroy() -> void:
	move_to.start(destroy_pos, MoveTo.Method.IN)

func start_mask() -> void:
	mask.process_mode = PROCESS_MODE_INHERIT
	
func start_cucumber() -> void:
	cucumber.process_mode = PROCESS_MODE_INHERIT
	cucumber.spawn_cucumber()

func idle() -> void:
	$AnimatedSprite2D.play("idle")
	sfx_neutral.play()

func angry() -> void:
	$AnimatedSprite2D.play("angry")
	if not is_angry:
		$"../UIGame".angry_client(2.0)
	angry_timer.start()
	is_angry = true
	sfx_angry.play()

func happy() -> void:
	$AnimatedSprite2D.play("happy")
	sfx_happy.play()

func _on_move_to_started() -> void:
	in_animation = true

func _on_move_to_ended() -> void:
	in_animation = false
	
	print(position.distance_to(destroy_pos))
	if position.distance_to(destroy_pos) <= 30:
		queue_free()
		return
	
	idle()
