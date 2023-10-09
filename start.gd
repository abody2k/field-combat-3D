extends Node2D



func _ready():
	
	#check if the player has name, if not then direct them to first time menu
	
	if not FileAccess.file_exists("user://username.save"):
		
		#does not exist
		get_tree().change_scene_to_file("res://first_time_menu.tscn")
		
	else :
		var file =FileAccess.open_encrypted_with_pass("user://username.save",FileAccess.READ,"Hola madri")
		var json = JSON.new()
		json.parse(file.get_line())
		
		print("your name is ", json.get_data()["username"])
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#start the game
func _on_button_button_down():
	pass # Replace with function body.
