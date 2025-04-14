extends KinematicBody2D

onready var playercast = $playercast
const BULLET = preload("res://scenes/PearlBullet.tscn")
onready var player = get_tree().get_nodes_in_group("Player")[0]

export (int, 1, 10) var health: int = 8
var isDead: bool = false

func _ready():
	get_node("AnimationPlayer").play("idle")
	$delay_attack.start()
	aim()

func damage_ctrl(damage) -> void:
	if health > damage:
		health -= damage
		$AnimationPlayer.play("hit")
	else:
		health -= damage
		$AnimationPlayer.play("deadhit")
		isDead = true
		Global.coin += 75

		yield(get_tree().create_timer(0.5), "timeout")
		queue_free()
			
func aim():
	playercast.cast_to = Vector2.ZERO

func _process(_delta: float):
	if isDead == false:
		playercast.cast_to = to_local(player.global_position) 
		if playercast.cast_to.x >= 0:
			$Sprite.flip_h = true
		else:
			$Sprite.flip_h = false

func _on_delay_attack_timeout():
	
	if player.global_position != null and abs(playercast.cast_to.x) <= 600 and isDead == false:
		get_node("AnimationPlayer").play("fire")
		yield(get_tree().create_timer(0.5), "timeout")
		var bullet = BULLET.instance()
		get_parent().add_child(bullet)
		if $Sprite.flip_h == false:
			bullet.global_position = self.global_position + Vector2(-35, 15)
		else:
			bullet.global_position = self.global_position + Vector2(35, 15)
		bullet.direction = to_local(playercast.get_collision_point()).normalized()
