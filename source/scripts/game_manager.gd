extends Node

const GAME_SCENE_UID: String = "uid://b180gverqsa44"
const GAME_OVER_SCENE_UID: String = "uid://li70u366qhr0"
const TITLE_SCREEN_SCENE_UID: String = "uid://drcepl1658dpn"

var best_score : int = 0
var score : int = 0
var health : int = 3
var win_clients = 0

var patience_time : float = 50.0
var patience_time_min : float = 20.0

var win_strike : int = 0

func patience_time_update() -> void:
	var patience_time_desired: float = GameManager.patience_time - (5 * GameManager.win_clients)
	GameManager.patience_time = max(patience_time_desired, GameManager.patience_time_min)
