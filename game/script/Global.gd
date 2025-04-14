extends Node

var checkpoint_pos = Vector2(65, 180)
var coin: int = 0
var chest_empty: bool = false
var crow1: bool = false
var crow2: bool = false
var world: int




func save_data():
	var file = File.new()
	file.open("user://save", File.WRITE_READ)
	file.store_var({
		"coin": coin,
		"chest_empty": chest_empty,
		"checkpoint_pos": checkpoint_pos,
		"crow1": crow1,
		"crow2": crow2,
		"world": world
		
	})
	file.close()

func load_data():
	var file = File.new()
	if not file.file_exists("user://save"):
		return false
	file.open("user://save", File.READ)

	var savedData = file.get_var()
	checkpoint_pos = savedData["checkpoint_pos"]
	coin = savedData["coin"]
	chest_empty = savedData["chest_empty"]
	crow1 = savedData["crow1"]
	crow2 = savedData["crow2"]
	world = savedData["world"]
	file.close()
	return true

func new_data():
	checkpoint_pos = Vector2(65, 180)
	chest_empty = false
	coin = 0
	crow1 = false
	crow2 = false
	world = 1
	save_data()


