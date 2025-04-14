extends KinematicBody2D

var sprite
var initial_position
var target_position
var move_speed = 220
var dialogue_started = false

onready var dialogue = get_node("Dialogue")

func _ready():
	Global.load_data()
	if Global.crow2 == true:
		queue_free()
	
	dialogue.visible = false
	sprite = get_node("Sprite")
	initial_position = sprite.position
	target_position = initial_position
	get_node("AnimationPlayer").play("idle")

func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		dialogue.visible = true
		use_dialogue()

func _on_Area2D_body_exited(body):
	var chatbox = get_node("Area2D")	
	if body.is_in_group("Player"):		
		get_node("AnimationPlayer").play("fly")
		chatbox.queue_free()
		$Sprite.flip_h = true
		yield(get_tree().create_timer(0.5), "timeout")
		target_position.x -= 500
		yield(get_tree().create_timer(0.5), "timeout")
		target_position.y -= 220
		yield(get_tree().create_timer(1), "timeout")
	
		queue_free()
		Global.crow2 = true
		Global.save_data()

func _process(delta: float):
	var current_position = sprite.position
	var direction = target_position - current_position
	var distance = direction.length()

	if distance > 0:
		var move_amount = move_speed * delta
		if move_amount > distance:
			move_amount = distance
		var move_vector = direction.normalized() * move_amount
		sprite.position += move_vector

func use_dialogue():
	dialogue_started = true
	var dialogue = get_node("Dialogue")
	dialogue.current_dialogue_id = 6
	dialogue.max_dialogue = 11
	if dialogue:
		dialogue.start()
