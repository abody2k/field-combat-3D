extends CharacterBody3D



@export var speed : float
var readyToAttack=false
var rocket = preload("res://rocket.tscn")
var velo = Vector3.ZERO

func _ready():
	$AnimationPlayer.play("rotation")
	pass
func _physics_process(delta):
	velo.x=-Input.get_axis("moveUP","moveDOWN")
	velo.z=Input.get_axis("moveLEFT","moveRIGHT")
	print(velo)
	velocity = velo * speed 
	move_and_slide()
	
	if Input.is_action_just_pressed("attack") and readyToAttack:
		var tempRocket = rocket.instantiate()
		tempRocket.target=$target
		tempRocket.position = position + Vector3.DOWN * 3
		
		pass
	
	pass


func _on_reloading_timeout():
	readyToAttack=true
	pass # Replace with function body.
