extends "res://scripts/AI.gd"


var rocket = preload("res://scenes/rocket.tscn")
func _ready():
	$AnimationPlayer.play("running")
	pass
	
var reloaded=true	
func aiming(delta : float):
	if not is_instance_valid(target):
		state=SEARCHING
		return
	$AnimationPlayer.play("attacking")
	look_at(Vector3(target.position.x,position.y,target.position.z),Vector3.UP,true)
#	state=SHOOTING
	attack()
	
	
func makeMeRed():
	(($Armature_001/Skeleton3D/Cube as MeshInstance3D).mesh.surface_get_material(0) as Material).albedo_color = Color.RED
	(($Armature_001/Skeleton3D/cannon as MeshInstance3D).mesh.surface_get_material(0) as Material).albedo_color = Color.RED
	
	pass
func move(delta : float =0):

	if state == DISABLED or freezed:
		return
	look_at(Vector3(path[0].x* get_parent().gridRectSize.x,position.y,path[0].y* get_parent().gridRectSize.y),Vector3.UP,true)	
	velocity =( Vector3(path[0].x* get_parent().gridRectSize.x,0,path[0].y* get_parent().gridRectSize.y)-position).normalized() * speed
	move_and_slide()
	
		
#checks if there is a player or not,if there is and in range it attacks if not it moves
#towards it and if there is no player it looks for the final point to go to

	
	
#func onShooting():
#	if state== DISABLED :
#		return
#
#	if !target:
#		state= SEARCHING
#		return
#
#	if  target.position.distance_to(position)> shootingRange :
#		state = SEARCHING
#		return
#
#
#
#	pass
#





	
#	pass

func attack():
	if not reloaded :
		return
	state= SHOOTING
		
	print("attacking")
	$AnimationPlayer.play("attacking")
		
		
#	if name.find("En")>=0 :
#		print("Shooting as AI")
#	else:
#		print("Shooting as mini AI")
#
	
		
	if !is_instance_valid(target):
		state=SEARCHING
		return
	

	if target and target is CharacterBody3D:
		#shoot
		#create rocket
		#change its rotation and position
		#put it in the world
		#
		
		var myRocket = rocket.instantiate()

		myRocket.position = $Armature_001/Skeleton3D/cannon/Node3D.global_position
		myRocket.target = target.position
		myRocket.myTeam = team
		
		get_parent().add_child(myRocket)
		myRocket.look_at(target.position)
#		print(target)
#		(myRocket as CharacterBody3D).look_at(target.position)
		reloaded=false
		$shootingTimer.start()
		state= SEARCHING
#		pass
#	if target.position.distance_to(position) <= shootingRange:
#		$shootingTimer.start()
#	else :
#		state= SEARCHING
#		$AnimationPlayer.play("running")
		
	pass # Replace with function body.
	
	
	pass
func _on_shooting_timer_timeout():
	reloaded=true
	


func _ObjectEnteredDetectionRange(body):
#	print("Happened from here")
	ObjectEnteredDetectionRange(body)
	pass # Replace with function body.
