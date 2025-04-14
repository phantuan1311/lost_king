extends KinematicBody2D

func _ready():
	Global.load_data()
	if Global.chest_empty == false:
		$AnimationPlayer.play("idle")
	else:
		$AnimationPlayer.play("empty_idle")
		
		
func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		if Global.chest_empty:
			$AnimationPlayer.play("empty_open")		
		else: 
			$AnimationPlayer.play("open")
			Global.coin += 100
			Global.chest_empty = true
			Global.save_data()


func _on_Area2D_body_exited(body):
	if body.is_in_group("Player"):
		$AnimationPlayer.play("close")
