extends "res://scripts/AI.gd"


var target2 : CharacterBody3D 
var counter : float =0.0
#the first enemy is for attacking
@export var radius : float = 1.0
var firing = false
var absorbing =false
const rocket = preload("res://scenes/rocket.tscn")
func attack():
	
	if not is_instance_valid(target):
		return
	var myRocket = rocket.instantiate()
	
	myRocket.position = $aim.global_position 
	myRocket.target = target.position
	myRocket.myTeam = team
	myRocket.rocketSpeed = 20.0
	get_parent().add_child(myRocket)
	(myRocket as CharacterBody3D).look_at(target.position)
	if state != RETREATING:
		state = SEARCHING
	$shooter.start()
	
	
func unSuck():
	print(target2)
	if target2 == null or not absorbing:
		return
	
	remove_child(target2)
	
	get_parent().add_child(target2)
	target2.position= global_position
	target2.call("unFreezeMe")
	pass
	
	
func onTweeningFinished():
	if target2.get_parent() == self:
		return
	$detector.monitoring=false
	
	get_parent().remove_child(target2)
	add_child(target2)
	state = RETREATING
	pass
	
	
func absorb():
	target2.call("freezeMe")
	var tween = create_tween()
	tween.tween_property(target2,"position",position,1)
	tween.tween_callback(onTweeningFinished)
	absorbing=true
	tween.play()
	
	pass

func goAbsorb(delta : float):
	print('trying to absrob')
	look_at(Vector3(target2.position.x,position.y,target2.position.z))
	velocity =( basis.z )* speed
	move_and_slide()
	print( position.distance_squared_to( Vector3(target2.position.x,position.y,target2.position.z)))
	if position.distance_squared_to( Vector3(target2.position.x,position.y,target2.position.z))<=1 :
		state=SHOOTING
		absorb()
	pass
	
	
	
func flyAround(delta : float):
	
	
#	velocity =( Vector3(target.position.x,0,target.position.z)- position )* speed
#	move_and_slide()
	if target2:
		goAbsorb(delta)
			
	counter += delta 
	position += Vector3(cos(counter) ,0,sin(counter) ) * delta * radius
	if not firing:
		firing = true
		attack()

	
	
#	position += Vector3( exp(-0.1*counter) ,0, exp(-0.1 *counter))  * delta 



func move (delta : float=0):
	velocity =( Vector3(target.position.x,position.y,target.position.z)- position )* speed
	move_and_slide()
	if not firing:
		firing = true
		attack()



func _on_detector_body_entered(body):
	#avoid allies
	#if enemy check if we already have target if so then go towards it and suck it

	print(body.name)
	print("IM UFO EN")
	if "team" in body :
		if body.team == team:
			print('cant absrob my team or attack a flying objects')
			return
		if body.position.y>1 :
			target=body
			return
			
		elif is_instance_valid(target) and target != null and target2 == null and body != target:
			target2 = body
		elif target == null or not is_instance_valid(target):
			target = body
	elif not body is StaticBody3D:
		target = body
	
	pass # Replace with function body.


func _on_shooter_timeout():
		
	if target and is_instance_valid(target):
		attack()
	else :
		firing=false
	pass # Replace with function body.
