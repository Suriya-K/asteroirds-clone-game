extends Node2D

signal hit(object_type)

@export var asteroid_speed = 100
@onready var anim_player = get_node("AnimationPlayer")

var small_asteroid = load("res://prefabs/asteroid_type_1.tscn")

var velocity = Vector2.ZERO
var is_small_asteroid = false

func _ready():
	self.name = "asteroid1"
	self.add_to_group('asteroid')

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.position += velocity * asteroid_speed * delta

func spawn_small_asteroid():
	if(!is_small_asteroid):
		var root_scene = get_parent()
		var rand_scale = randf_range(0.2,0.5)
		for i in range (2):
			var asteroid = small_asteroid.instantiate()
			var small_spawning_porint = Vector2(randf_range(-20, 20), randf_range(-20, 20))
			var random_speed = randf_range(100,150)
			root_scene.call_deferred('add_child',asteroid)
			asteroid.position = small_spawning_porint + self.position
			asteroid.velocity = small_spawning_porint.normalized()
			asteroid.asteroid_speed = random_speed
			asteroid.scale = Vector2(rand_scale,rand_scale)
			var game_controller = get_parent().get_node("GameController")
			asteroid.connect("hit",Callable(game_controller,"_on_update_socre"))
			asteroid.is_small_asteroid = true

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_area_2d_area_entered(area):
	var area_object = area.get_parent()
	if(area_object.is_in_group("bullet")):
		hit.emit("bullet")
		area_object.queue_free()
		spawn_small_asteroid()
		anim_player.play("asteroid_hit_queue")
	


func _on_area_2d_body_entered(body):
	if(body.name == "Ship"):
		hit.emit("ship")
		anim_player.play("asteroid_hit_queue")
