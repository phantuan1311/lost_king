extends KinematicBody2D

const SPEED = 128
const FLOOR = Vector2(0, -1)
const GRAVITY = 18
const JUMP_HEIGHT = 350
const DOUBLE_JUMP_HEIGHT = 300
const CAST_ENEMY = 42

var immunity: bool = false
var health: int = 8
var damage: int = 1
var state_machine
var canAttack = true
var canDoubleJump = true
var isDead: bool = false

var last_checkpoint: Area2D = null


onready var motion = Vector2.ZERO
onready var immunity_timer: Timer = $Timer

func _ready():	
	state_machine = $AnimationTree.get('parameters/playback')
	get_node("AnimationTree").active = true
	immunity_timer.start()
	global_position = Global.checkpoint_pos

func _process(_delta):
	motion_ctrl()
	direction_ctrl()
	attack_ctrl()

func get_axis() -> Vector2:
	var axis = Vector2.ZERO
	axis.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	return axis

func motion_ctrl():
	motion.y += GRAVITY
	if isDead:
		motion.x = 0
		Global.coin = 0
		Global.save_data()

	if isDead == false:
		
		if get_axis().x == 1:
			$Sprite.flip_h = false
		elif get_axis().x == -1:
			$Sprite.flip_h = true

		if get_axis().x != 0:
			motion.x = get_axis().x * SPEED
		else:
			motion.x = 0

		if is_on_floor() or isDead:  
			if get_axis().x != 0:
				state_machine.travel('run')
			else:
				state_machine.travel('idle')
			if Input.is_action_just_pressed("jump") and not isDead:  
				motion.y -= JUMP_HEIGHT
				canDoubleJump = true

		else:
			if motion.y < 0:
				state_machine.travel('jump')
			else:
				state_machine.travel('fall')
			if Input.is_action_just_pressed("jump") and canDoubleJump and not isDead:
				motion.y = -DOUBLE_JUMP_HEIGHT
				canDoubleJump = false
	motion = move_and_slide(motion, FLOOR)

func direction_ctrl():
	match $Sprite.flip_h:
		true:
			$RayEnemy.cast_to.x = -CAST_ENEMY
		false:
			$RayEnemy.cast_to.x = CAST_ENEMY
			
func attack_ctrl():
	if get_axis().x == 0 and Input.is_action_just_pressed("attack") and canAttack:
		match state_machine.get_current_node():
			"idle":
				state_machine.travel("attack")
				canAttack = false
	
	if state_machine.get_current_node() == "attack":
		$RayEnemy.enabled = true
	else:
		$RayEnemy.enabled = false
	
	var col = $RayEnemy.get_collider()
	if $RayEnemy.is_colliding() and canAttack:
		if col.is_in_group("enemy"):
			col.damage_ctrl(damage)
			canAttack = false
	
	if state_machine.get_current_node() != "attack":
		canAttack = true

func damage_ctrl(damage) -> void:
	if not immunity and isDead == false :
		health -= damage
		state_machine.travel("hit")
		
		if health <= 0:
			get_node("AnimationTree").active = false
			$AnimationPlayer.play("dead")
			isDead = true
		else:
			immunity = true
			immunity_timer.start()
			yield(get_tree().create_timer(0.15), "timeout") 
			blink_character()
		
func blink_character() -> void:
	for _i in range(1, 6):
		yield(get_tree().create_timer(0.1), "timeout")
		$Sprite.modulate = Color(1, 1, 1, 0.8)
		yield(get_tree().create_timer(0.1), "timeout")
		$Sprite.modulate = Color(1, 1, 1, 0.4)

func _on_Timer_timeout():
	immunity = false
	$Sprite.modulate = Color(1, 1, 1, 1)

func hit_checkpoint():
	Global.checkpoint_pos = global_position
	Global.save_data()
