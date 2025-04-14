extends KinematicBody2D

export var  direction = Vector2(1,1)


var motion = Vector2(0,0)
var speed = 1800
func _physics_process(delta):
	$Sprite.rotation = direction.angle()
	$Area2D.rotation = direction.angle()
	motion = direction * speed * delta * 10
	motion = move_and_slide(motion, Vector2(0,-1))


func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		body.damage_ctrl(1)
		
	if body.is_in_group("map") or body.is_in_group("Player"):
		get_node("AnimationPlayer").play("hit")
		yield(get_tree().create_timer(.15), "timeout")
		queue_free()
