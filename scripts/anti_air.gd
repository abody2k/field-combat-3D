extends CharacterBody3D
const rocket = preload("res://scenes/rocket.tscn")
var targets = []
# Called when the node enters the scene tree for the first time.
func _ready():

	pass # Replace with function body.
enum MODES {WAITING,AIMING,ATTACKING,RELOADING}
var current_mode = MODES.WAITING
const team=1
func aiming(delta : float =0):
	if  targets.size() < 1 :
		current_mode = MODES.WAITING
		return
		
#	look_at(targets[0].position)
#	return

#	return
#	var direction: Vector3 = targets[0].global_transform.origin- global_transform.origin
	var direction : Vector3 = targets[0].global_transform.origin - $ball.global_position
	
	
#	var gt =global_transform.looking_at(direction,Vector3.UP)
#	global_transform = gt

	var bas =Basis.looking_at(direction,Vector3.UP)
#	look_at(targets[0].position)
#	return
#	$ball.look_at((targets[0].position))

#	rotate(Vector3(0,1,0), 2*-PI/3)
#	return
	$ball.global_transform.basis = $ball.global_transform.basis.slerp(bas,delta*4)
	
#	print(($ball.global_transform.basis.z.dot(direction.normalized())))
#	return
#	print(($ball.global_transform.basis.z.dot(direction.normalized())) )
	if ($ball.global_transform.basis.z.dot(direction.normalized())) <-0.9999 and current_mode != MODES.RELOADING:
		print("ATTACKING !!!")
		current_mode=MODES.ATTACKING
		attacking()
		
	pass

func attacking():
	#create rocket
	#make it go to the target
	#restart the timer
	var myRocket = rocket.instantiate()
	
	myRocket.position = $ball/ball/rocketAimingPoint.global_position 
	myRocket.target = targets[0].position
	myRocket.myTeam = 1
		
	get_parent().add_child(myRocket)
	(myRocket as CharacterBody3D).look_at(targets[0].position)
	current_mode =MODES.RELOADING
	$Timer.start()
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	

	match current_mode :
		MODES.AIMING,MODES.RELOADING:
			aiming(delta)
			pass
	pass


func _on_area_3d_body_shape_entered(_body_rid, body, _body_shape_index, _local_shape_index):
	

	if body is CharacterBody3D and (body.name as String).find("En")<0 :

		#they caough us
		targets.append(body)

		current_mode= MODES.AIMING
		pass
	pass # Replace with function body.


func _on_area_3d_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	if targets.has(body):
		print("left the target area ", body.name)
		targets.remove_at(targets.find(body))
	
	pass # Replace with function body.


func _on_timer_timeout():
	current_mode = MODES.AIMING
	
	if targets.size()<1 :
		return
		
	if !is_instance_valid(targets[0]):
		targets.remove_at(0)
		if targets.size() <1:
			current_mode = MODES.WAITING
			return
		return
	pass # Replace with function body.
