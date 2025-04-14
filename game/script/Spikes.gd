extends Area2D

var damage_timer: float = 0.0
const damage_interval: float = 0.1

signal spike_damage

func _on_Spikes_body_entered(body):
	if body.is_in_group("Player"):
		body.damage_ctrl(1)
		emit_signal("spike_damage", 1)
		damage_timer = 0.0

func _process(delta):
	damage_timer += delta  
	if damage_timer >= damage_interval:
		for body in get_overlapping_bodies():
			if body.is_in_group("Player"):
				body.damage_ctrl(1)
				emit_signal("spike_damage", 1)
		
		damage_timer -= damage_interval  
