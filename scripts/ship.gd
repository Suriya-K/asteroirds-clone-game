extends CharacterBody2D

signal dead

@export var move_speed = 10
@export var weight = 0.05
@export var rotation_speed = 3

@onready var screen_size = get_viewport_rect().size

var rotate = 0

func _ready():
	pass
	
func _process(delta):
	get_input()
	wrap_player()
	self.rotation += rotate * rotation_speed * delta
	self.move_and_collide(self.velocity * delta)
	
func get_input():
	var input_move_axis = Input.get_axis("ui_down","ui_up")
	rotate = Input.get_axis("ui_left","ui_right")
	self.velocity += self.transform.x  * input_move_axis * move_speed
	if(input_move_axis < 0):
			input_move_axis = 0
	if (input_move_axis == 0): 
		self.velocity.y = lerpf(self.velocity.y,0,weight)
		self.velocity.x = lerpf(self.velocity.x,0,weight)
		

func wrap_player():
	self.position.x = wrapf(self.position.x,0,screen_size.x)
	self.position.y = wrapf(self.position.y,0,screen_size.y)


func _on_spawn_bullet_point_spawn_bullet(bullet, direction, pos):
	var root_scence = get_tree().get_root()
	var spawn_bullet = bullet.instantiate()
	root_scence.add_child(spawn_bullet)
	spawn_bullet.position = pos
	spawn_bullet.rotation = direction
	spawn_bullet.t = self.transform

func _on_game_controller_player_dead():
	dead.emit()
