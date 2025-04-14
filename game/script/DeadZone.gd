extends Area2D

func _on_DeadZone_body_entered(body):
	if body.is_in_group("Player"):
		body.immunity = false
		body.damage_ctrl(99)
