extends KinematicBody2D

onready var sail: AnimatedSprite = get_node("AnimatedSail")
var active: bool = false
var movementSpeed: float = 1.2
var timer: float = 0.0

func _ready():
	sail.play("no_wind")
	active = false

func _physics_process(delta):
	print(timer)
	if active:
		move()
		timer += delta
		if timer >= 3.0:
			Global.checkpoint_pos = Vector2(175, 250)
		if timer >= 5.0:
			active = false
			get_tree().change_scene("res://scenes/World2.tscn")
			

func _on_Area2D_body_entered(body):
	if body.is_in_group("Player") and not active:
		sail.play("trans_to_wind")
		timer = 0.0
		sail.play("wind")
		active = true

func move():
	position.x += movementSpeed
