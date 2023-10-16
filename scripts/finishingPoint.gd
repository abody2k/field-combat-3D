extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	#play the winning sound
	
	#if it's the drone then finish the game
	if body.name=="UFO" :
		#disable all the units radar
		#give them the same destination point
		for node in get_parent().get_children():
			if "team" in node and "target" in node:
				node.call("disable_me")
			
		$Timer.start()
		
		
	pass # Replace with function body.


func _on_timer_timeout():
	
	get_tree().change_scene_to_file("res://scences/statistics.tscn")
	
	pass # Replace with function body.
