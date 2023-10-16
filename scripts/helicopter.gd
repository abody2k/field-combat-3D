extends "res://scripts/AI.gd"

var counter : float =0.0
@export var radius : float =1.0
var forward : Vector3 = Vector3.UP * -100
@export var temporal = 0.0
func flyAround(delta : float):
	counter += delta*10
	position+= Vector3(cos((deg_to_rad(counter))),0,sin(deg_to_rad(counter))) * radius* delta
	
#	counter = counter - int(counter)

#	if counter < 0.5 * 5 :
	return
	if  int(counter)%int (radius) < radius /2 :
		position+= Vector3(cos((deg_to_rad(counter))),0,sin(deg_to_rad(counter))) * radius * delta
		print("doing that")
	else :
		if forward == Vector3.UP * -100 :
			#set a vector so the helicopter will go to 
			forward =  ( (Vector3(cos((counter+0.7)),0,sin((counter+0.7))) * radius))
#		elif 
		print("doing this")
		position+= (-position + (Vector3(cos((counter+0.7)),0,sin((counter+0.7))) * radius)) * delta
#	else :
		#move directly 
#		pass
#		position+= Vector3(cos(counter),0,0)* radius * delta
#		pass
#	if counter > 5 :
#		counter=0
#	move_and_slide()
	pass
func move(delta : float=0):
	velocity = speed * (target.position-position)
	move_and_slide()
	pass
