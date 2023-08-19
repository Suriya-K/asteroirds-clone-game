extends Node2D

@export var bullet_speed = 1000
var t: Transform2D

func _ready():
	self.add_to_group("bullet")

func _physics_process(delta):
	self.position += t.x * bullet_speed  * delta


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

