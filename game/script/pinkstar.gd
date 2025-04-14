extends KinematicBody2D

const FLOOR = Vector2(0, -1)
const GRAVITY = 16
const MIN_SPEED = 32
const MAX_SPEED = 100
var speed: int

export (int, 1, 10) var health: int = 5

onready var motion: Vector2 = Vector2.ZERO
onready var can_move: bool = true
onready var direction: int = 1

func _ready() -> void:
	get_node("AnimationPlayer").play("run")
	speed = MIN_SPEED

func _process(_delta) -> void:
	if can_move:
		motion_ctrl()
	
func motion_ctrl() -> void:
	if direction == 1:
		get_node("Sprite").flip_h = true
	else:
		get_node("Sprite").flip_h = false

	var wall_collision = is_on_wall() or not get_node("Raycast/Ground").is_colliding()
	if wall_collision:
		direction *= -1
		get_node("Raycast").scale.x *= -1
		$Find_player.scale.x *= -1
		$attack.scale.x *= -1

	motion.y += GRAVITY
	motion.x = speed * direction

	motion = move_and_slide(motion, FLOOR)

func damage_ctrl(damage) -> void:
	if can_move:
		if health > damage:
			health -= damage
			$AnimationPlayer.play("hit")
		else:
			$AnimationPlayer.play("deadhit")
			Global.coin += 45


func _on_AnimationPlayer_animation_started(anim_name):
	match anim_name:
		"hit":
			can_move = false
		"deadhit":
			can_move = false
		"attack":
			can_move = true

func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		"hit":
			if health > 0:
				if speed == MAX_SPEED:
					get_node("AnimationPlayer").play("attack")
					can_move = true
				else:
					get_node("AnimationPlayer").play("run")
					can_move = true
			else:
				get_node("AnimationPlayer").play("deadhit")

		"deadhit":
			queue_free()
			

func _on_Find_player_body_entered(body):
	if body.is_in_group("Player"):
		speed = MAX_SPEED
		get_node("AnimationPlayer").play("attack")

func _on_Find_player_body_exited(_body):
	speed = MIN_SPEED
	get_node("AnimationPlayer").play("run")

func _on_attack_body_entered(body):
	if body.is_in_group("Player"):
		$AnimationPlayer.play("attack")
		body.damage_ctrl(1)

func _on_attack_body_exited(body):
	if body.is_in_group("Player"):
		$AnimationPlayer.play("run")
