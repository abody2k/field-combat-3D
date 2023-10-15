extends "res://scripts/AI.gd"


const SPEED = 10
var timer=0
##the tank movement is different because it needs to go in a circular path if it wants to rotate
var firstDeg : Basis = Basis()
const CANNON_ROTATION_TRESHOLD=0.8
func _ready():
	pass
	
#	target = get_parent_node_3d().get_node("target")

func aiming(delta : float):
	var b = Basis()
	$cannonBase.basis = $cannonBase.basis.slerp(Basis.looking_at(Vector3(target.position.x,0,target.position.z)- $cannonBase.global_position),delta)
	b= Basis()
	if not Vector3(0,target.position.y,0)-$cannonBase/cannon.position == Vector3.ZERO:
		$cannonBase/cannon.basis = $cannonBase/cannon.basis.slerp(Basis.looking_at(target.position-$cannonBase/cannon.global_position),delta)
	# taking the direction vector (difference between target and current object positions) normalizing it and doing
	#dot product gives us a check if an object is looking at another one, using a threshold like 0.9 means they
	#are looking at each other directly 
	
	if ($cannonBase/cannon.global_position-target.position).normalized().dot($cannonBase/cannon.basis.z) >=CANNON_ROTATION_TRESHOLD:
		finishedAiming= true
	else :
		finishedAiming = false
	
	pass	
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
