extends "res://scripts/AI.gd"


const SPEED = 10
var timer=0
##the tank movement is different because it needs to go in a circular path if it wants to rotate
var firstDeg : Basis = Basis()
const CANNON_ROTATION_TRESHOLD=0.9
const rocket = preload("res://scenes/rocket.tscn")
var finishedReloading=true
	
#	target = get_parent_node_3d().get_node("target")
##function that is used for aiming
func aiming(delta : float):

	# IMPORTANT NOTES !!!
	# FORWARD DIRECTION IS -Z NOT +Z WHICH MEANS THE OPPOSITE OF THE BLUE ARROW
	#THE DIFFERENCE BETWEEN GLOBAL POSITING AND ORIGIN IS THE OFFSET IN THE MAIN TREE NODE
	#WHEN USING LOOK IT USE THE GLOBAL POSITIN
	#WHEN DEALING WITH BASIS AND ROTATIONS AND LOOKING AT ANOTHER OBJECT THE BASIS CREATED FROM THIS FUNCTION
	#WILL REMOVE ALL PREVIOUS SCALING AND USING LERP WILL BE BETTER THAN SLERP BECAUSE OF THE SCALING ISSUE
	#ORTHONORMALIZED METHOD WILL MAKE THE BASIS NORMALIZED
	#GETTING THE SCALE AND APPLYING IT AFTRE ROTATION WILL SOLVE THE ROTATION ISSUE
	
#
#	$cannonBase.look_at(target.global_position)
#	return
	
	if not is_instance_valid(target):
		state= SEARCHING
		return 
	if shootingRange > position.distance_squared_to(target.global_position):
		state= SEARCHING
		return
		
	var direction = target.global_position - $cannonBase.global_position
#	print(target.position,target.global_position)
	#no scaling handling solution 
	$cannonBase.global_transform.basis = $cannonBase.global_transform.basis.slerp(Basis.looking_at(direction),delta*7)
#	print (($cannonBase.global_transform.basis as Basis).get_scale())
	
	

	#FOR SCALING
#	var myScale = $cannonBase.global_transform.basis.get_scale()
#	$cannonBase.global_transform.basis = lerp(($cannonBase.global_transform.basis as Basis).orthonormalized(),Basis.looking_at(direction),delta)
#	$cannonBase.global_transform.basis=$cannonBase.global_transform.basis.scaled(myScale)
	
#	print (($cannonBase.global_transform.basis as Basis).get_scale())
#	return
#	if not Vector3(0,target.position.y,0)-$cannonBase/cannon.position == Vector3.ZERO:
#		pass
#		$cannonBase/cannon.basis = $cannonBase/cannon.basis.slerp(Basis.looking_at(Vector3(0,target.position.y,0)-$cannonBase/cannon.position),delta)
	# taking the direction vector (difference between target and current object positions) normalizing it and doing
	#dot product gives us a check if an object is looking at another one, using a threshold like 0.9 means they
	#are looking at each other directly 
#	print(($cannonBase/cannon.global_position-target.position).normalized().dot($cannonBase/cannon.global_transform.basis.z))
	if ($cannonBase/cannon.global_position-target.position).normalized().dot($cannonBase/cannon.global_transform.basis.z) >=CANNON_ROTATION_TRESHOLD and finishedReloading:

		
		finishedReloading=false
		attack()
		$shootingTimer.start()
		
		
		

	
	pass
	
func attack():
	#create rocket
	#make it go to the target
	#restart the timer
	var myRocket = rocket.instantiate()
	
	myRocket.position = $cannonBase/cannon/target.global_position 
	myRocket.target = target.position
	myRocket.myTeam = team
	
	get_parent().add_child(myRocket)
	(myRocket as CharacterBody3D).look_at(target.position)
	state = SEARCHING

	
		
func move(delta : float =0):
	
#	print(rad_to_deg(position.angle_to(target.position)))

#		basis =lerp(b,firstDeg,timer)

#	var b = Basis.looking_at(Vector3(path[0].x,0,path[0].y)-position,Vector3(0,1,0))
	var b = Basis.looking_at(target.position-position,Vector3(0,1,0),false)
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


func _on_enemey_detector_body_entered(body):
	ObjectEnteredDetectionRange(body)
	pass # Replace with function body.


func _on_shooting_timer_timeout():
	finishedReloading=true
	
	pass # Replace with function body.
