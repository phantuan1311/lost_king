extends CanvasLayer

onready var player: KinematicBody2D = get_tree().get_nodes_in_group("Player")[0]
var isGameOver = false
var canRestart = false

func _ready():
	get_node("AnimationPlayer").play("PlayAgain")
	get_node("TextureProgress").max_value = player.health

func _process(_delta):
	if is_instance_valid(player):
		get_node("TextureProgress").value = player.health
		var coinString = ""
		if Global.coin < 10:
			coinString = "0" + str(Global.coin)
		else:
			coinString = str(Global.coin)
		$HBoxContainer/Label.text = coinString
	
func _on_TextureProgress_value_changed(value):
	if value <= 0:
		get_node("AnimationPlayer").play("GameOver")
		canRestart = true

func _on_AnimationPlayer_animation_started(anim_name):
	match anim_name:
		"GameOver":
			get_node("Control/VBoxContainer").visible = true
			canRestart = true

		"PlayAgain":
			get_node("Control/VBoxContainer").visible = false
			canRestart = false
			isGameOver = false

func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		"GameOver":
			isGameOver = true
			
func _input(event):
	var scene_name = "res://scenes/World" + str(Global.world) + ".tscn"

	if event is InputEventKey and event.is_pressed() and canRestart and isGameOver:
		if player != null:
			if not InputMap.action_has_event("ui_cancel", event):
				get_tree().change_scene(scene_name)

