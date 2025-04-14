extends CanvasLayer

export(String, FILE, "*.json") var d_file

var dialogue = []
var current_dialogue_id : int
var max_dialogue: int
var d_active = false

func _ready():
	$NinePatchRect.visible = false
	start()
	
func start():
	if d_active:
		return
	d_active = true
	$NinePatchRect.visible = true
	
	dialogue = load_dialogue()
	next_script()

func load_dialogue():
	var file = File.new()
	if file.file_exists(d_file):
		file.open(d_file, file.READ)
		return parse_json(file.get_as_text())

func _input(event):
	if not d_active:
		return
	if event.is_action_pressed("ui_accept"):
		next_script()

func next_script():
	if  visible == true:
		current_dialogue_id += 1
		if current_dialogue_id >= max_dialogue:
			$Timer.start()
			$NinePatchRect.visible = false
			return
		
		$NinePatchRect/Name.text = dialogue[current_dialogue_id]['name']
		$NinePatchRect/Chat.text = dialogue[current_dialogue_id]['text']
		#print(current_dialogue_id)


func _on_Timer_timeout():
	d_active = false
