extends Area2D

func _ready() -> void:
	$AnimationPlayer.play("idle")

func _on_Coin_body_entered(body):
	if body.is_in_group("Player"):
		$AnimationPlayer.play("join")
		Global.coin += 1

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "join":
		queue_free()

