extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	#slow it down
	if "team" in body:
		body.call("slowMeDown")
	pass # Replace with function body.


func _on_body_exited(body):
	#give it back its speed
	if "team" in body:
		body.call("moveFaster")
	pass # Replace with function body.
