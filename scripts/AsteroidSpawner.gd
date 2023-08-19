extends Node

@export var asteroid_type: Array[PackedScene]
@onready var spawn_point: PathFollow2D = get_node("Path2D/PathFollow2D")

var is_not_dead = true

func _on_timer_timeout():
	if (is_not_dead) :
		var seleted =randi() % asteroid_type.size()
		var parent_scene = self.get_parent()
		var player = self.get_parent().get_node("Ship")
		var asteroid = asteroid_type[seleted].instantiate()
		spawn_point.progress_ratio = randf()
		parent_scene.add_child(asteroid)
		var direction_to_player = (player.position - spawn_point.position).normalized()
		var rotate_angle = atan2(direction_to_player.y , direction_to_player.x)
		var game_controller = parent_scene.get_node("GameController")
		asteroid.connect("hit",Callable(game_controller,"_on_update_socre"))
		asteroid.velocity = direction_to_player
		asteroid.position = spawn_point.global_position
		asteroid.rotation = rotate_angle
		var rand_scale = randf_range(0.5,1.0)
		asteroid.scale = Vector2(rand_scale,rand_scale)
	


func _on_ship_tree_exiting():
	is_not_dead = false
