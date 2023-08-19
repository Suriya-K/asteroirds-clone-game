extends Node

var player_live = 3
var player_score = 0
var player_hi_score = 0
var is_game_over = false
var timeout_restart = false
var save_path = "user://high_score.bin"

signal player_dead

@onready var ui_player_stats = self.get_parent().get_node("Control/PlayerControl/PlayerStats")
@onready var ui_game_over = self.get_parent().get_node("Control/PlayerControl/GameOver")

func _ready():
	load_high_score()
	ui_player_stats.text = "LIVE: %s:\nSCORE: %s\nHI: %s\n " % [player_live,player_score,player_hi_score]

func _input(event):
	if is_game_over and timeout_restart :
		if event is InputEvent and event.pressed :
			get_tree().reload_current_scene()
	
func _on_update_socre(object_type):
	if(object_type == "bullet"): 
		player_score += calculate_score(1)
	if(object_type == "ship"): 
		player_live -= 1
	if(player_live <= 0):
		var ship = self.get_parent().get_node("Ship")
		player_dead.emit()
		ship.           queue_free()
	ui_updated()

func calculate_score(score):
	return randi_range(score,5)
	
func ui_updated():
	ui_player_stats.text = "LIVE: %s:\nSCORE: %s\nHI: %s\n " % [player_live,player_score,player_hi_score]
	

func _on_player_dead():
	ui_game_over.visible = true
	var restart_timer: Timer = get_node("RestartTimer")
	if(player_score >= player_hi_score):
		player_hi_score = player_score
	saved_high_score()
	restart_timer.start()
	is_game_over = true
	


func saved_high_score():
	var file = FileAccess.open(save_path,FileAccess.WRITE)
	file.store_16(player_hi_score)
	
func load_high_score():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path,FileAccess.READ)
		player_hi_score = file.get_16()
		


func _on_restart_timer_timeout():
	timeout_restart = true
