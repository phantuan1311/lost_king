extends Node2D

onready var boss: KinematicBody2D = get_tree().get_nodes_in_group("boss")[0]


func _ready():
	Global.world = 2
	Global.save_data()	
	get_node("Boss_life/boss_life").max_value = boss.health

func _process(_delta):
	if is_instance_valid(boss):
		get_node("Boss_life/boss_life").value = boss.health
