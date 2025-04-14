extends Node2D

export var mainGameScene : PackedScene

onready var loadGameButton = get_node("MarginContainer/VBoxContainer/LoadGame")


func _ready():
	Global.load_data()
	var scene_name = "res://scenes/World" + str(Global.world) + ".tscn"
	if Global.world == 1 and Global.checkpoint_pos == Vector2(65, 180):
		loadGameButton.hide()
	else:
		loadGameButton.show()
	print(scene_name)


func _on_NewGameButton_button_up():
	get_tree().change_scene(mainGameScene.resource_path)
	Global.new_data()

func _on_LoadGame_button_up():
	Global.load_data()
	var scene_name = "res://scenes/World" + str(Global.world) + ".tscn"
	get_tree().change_scene(scene_name)
	global_position = Global.checkpoint_pos

func _on_Exit_button_up():
	get_tree().quit()

