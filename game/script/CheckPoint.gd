extends Area2D

var active: bool = false
onready var animated: AnimatedSprite = get_node("AnimatedSprite")

func _on_CheckPoint_body_entered(body):
	if body.is_in_group("Player"):
		body.hit_checkpoint()
		if not active:
			if body.last_checkpoint != null:
				body.last_checkpoint.desactivate()
			body.last_checkpoint = self
			animated.play("active")
			active = true
			
func desactivate() -> void:
	animated.play("default")
	active = false
