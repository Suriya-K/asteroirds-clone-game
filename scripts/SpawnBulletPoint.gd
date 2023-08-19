extends Marker2D

signal spawn_bullet(bullet,direction,pos)

@export var bullet = preload("res://prefabs/bullet.tscn")
@onready var sound_laster = get_node("SoundLaser")

func _process(_delta):
	if(Input.is_action_just_pressed("ui_accept")):
		fire_bullet()
		sound_laster.play()

func fire_bullet():
	spawn_bullet.emit(bullet,self.global_rotation,self.global_position)
