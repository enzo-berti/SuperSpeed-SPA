extends Control

@export var tween_intensity: float
@export var tween_duration: float

@onready var StartButton: Button = $VBoxContainer/StartButton
@onready var QuitButton: Button = $VBoxContainer/QuitButton
@onready var level = preload("res://levels/level.tscn")
@onready var sfx_button: AudioStreamPlayer2D = $sfx_button

func _ready() -> void:
	game_manager.score = 0
	game_manager.health = 3

func _process(_delta: float) -> void:
	btn_hovered(StartButton)
	btn_hovered(QuitButton)

func start_tween(object: Object, property: String, final_val: Variant, duration: float):
	var tween = create_tween()
	tween.tween_property(object, property, final_val, duration)

func btn_hovered(button: Button):
	button.pivot_offset = button.size/2
	if button.is_hovered():
		start_tween(button, "scale", Vector2.ONE*tween_intensity, tween_duration)
	else:
		start_tween(button, "scale", Vector2.ONE, tween_duration)

func _on_start_button_pressed() -> void:
	sfx_button.play()
	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_packed(level)
	
func _on_quit_button_pressed() -> void:
	sfx_button.play()
	await get_tree().create_timer(0.2).timeout
	get_tree().quit()
	
