extends "res://scripts/AI.gd"

var counter : float =0.0
@export var radius : float =1.0
func flyAround(delta : float):
	counter += delta
	position+=Vector3(cos((counter)),0,sin((counter))) * radius * delta
	
#	move_and_slide()
	pass
func move(delta : float=0):
	velocity = speed * (target.position-position)
	move_and_slide()
	pass
