extends "res://scripts/AI.gd"


const SPEED = 10
var timer=0
##the tank movement is different because it needs to go in a circular path if it wants to rotate
var firstDeg : Basis = Basis()

func _ready():
	pass
	
#	target = get_parent_node_3d().get_node("target")

	
func move(delta : float =0):
	
#	print(rad_to_deg(position.angle_to(target.position)))

#		basis =lerp(b,firstDeg,timer)
	print(target.name)
#	var b = Basis.looking_at(Vector3(path[0].x,0,path[0].y)-position,Vector3(0,1,0))
	var b = Basis.looking_at(target.position-position,Vector3(0,1,0))
	global_transform.basis = global_transform.basis.slerp(b,delta* 2) 
	velocity = -basis.z * SPEED
	move_and_slide()
		
	pass

#func _physics_process(delta):
#	target= get_parent().get_node("Enj")
#	var b = Basis.looking_at(target.position-position,Vector3(0,1,0))
#	global_transform.basis = global_transform.basis.slerp(b,0.5) 
#	velocity = -basis.z * SPEED
#	move_and_slide()

#	pass
