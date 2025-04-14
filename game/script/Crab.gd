extends KinematicBody2D

const FLOOR = Vector2(0, -1)
const GRAVITY = 16
const MIN_SPEED = 32
const MAX_SPEED = 80
var speed: int 
var can_attack: bool = true
var health: int = 16
var is_attacking: bool = false
var can_move: bool = true

onready var player = get_tree().get_nodes_in_group("Player")[0]
onready var playercast = $playercast
onready var motion: Vector2 = Vector2.ZERO
onready var direction: int = 1

func _ready():
	$can_attack/can_acttack.disabled = false
	speed = MIN_SPEED
	aim()

func aim():
	playercast.cast_to = Vector2.ZERO
	
func _process(_delta) -> void:
	playercast.cast_to = to_local(player.global_position) - Vector2(0, 15) 
	if can_move:
		motion_ctrl()
		
	
func motion_ctrl() -> void:
	#print(abs(playercast.cast_to.x)) 
	if abs(playercast.cast_to.x) > 65:
		speed = MAX_SPEED
	else:
		speed = MIN_SPEED
		
	if direction == 1:
		get_node("Sprite").flip_h = true
	else:
		get_node("Sprite").flip_h = false

	var wall_collision = is_on_wall() or not get_node("Raycast/Ground").is_colliding()
	if wall_collision:
		direction *= -1
		get_node("Raycast").scale.x *= -1
		$can_attack.scale.x *= -1
		$attack.scale.x *= -1
		
	motion.y += GRAVITY
	
	if is_attacking:
		motion.x = 0
	else:
		if abs(playercast.cast_to.x) < 35:
			motion.x = 0
		else:
			motion.x = speed * direction
	
	motion = move_and_slide(motion, FLOOR)
	find_player()
	
func find_player() -> void:
	var player_position = player.global_position
	look_at(player_position)

func look_at(target_position: Vector2) -> void:
	if target_position.x < global_position.x:
		direction = -1
	else:
		direction = 1
		
func _on_Area2D_body_entered(body):
	if body.is_in_group("Player") and can_attack:
		$AnimationPlayer.play("attack")
		is_attacking = true


func _on_attack_body_entered(body):
	if body.is_in_group("Player") :
		body.damage_ctrl(1)

func _on_delay_attack_timeout():
	can_attack = true
	$can_attack/can_acttack.disabled = false


func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		"attack":
			can_attack = false
			is_attacking = false
			
			$can_attack/can_acttack.disabled = true
			if abs(playercast.cast_to.x) < 35:
				$AnimationPlayer.play("idle")
			else:
				$AnimationPlayer.play("run")
		"hit":
			if abs(playercast.cast_to.x) < 35:
				$AnimationPlayer.play("idle")
			else:
				$AnimationPlayer.play("run")

func damage_ctrl(damage) -> void:
	if health > damage:
		health -= damage
		$AnimationPlayer.play("hit")
	else:
		health = 0
		$AnimationPlayer.play("deadhit")
