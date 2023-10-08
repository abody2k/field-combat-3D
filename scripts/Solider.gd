extends "res://scripts/AI.gd"


var rocket = preload("res://rocket.tscn")
func _ready():
	
	print(state)

func onSearching():
	
	
#	print("Searching")
	if is_instance_valid(target) :
	
#		print("I'm",name," and my enemy is",target.name)
		if target.position.distance_to(position) <= shootingRange:

			$shootingTimer.start()	
			state=SHOOTING
		else :
			if path.size()<1 :
				return
#			if target.name=="j":
			#print("please note that im the bot",( Vector3(path[0].x* get_parent().gridRectSize.x,0,path[0].y* get_parent().gridRectSize.y)-position).normalized())
			velocity =( Vector3(path[0].x* get_parent().gridRectSize.x,0,path[0].y* get_parent().gridRectSize.y)-position).normalized() * speed
			move_and_slide()
			#print(Vector2(position.x,position.z).distance_squared_to( path[0]))
			if Vector2(position.x,position.z).distance_squared_to( path[0])<1:
				path.remove_at(0)
		pass
#	print("searching")
	else :
#		print("ENrolled here")

		if name.find("En")>=0:
#			print("I tired doing it as a bot")
			var obj=get_parent().get_node("j")

			ObjectEnteredDetectionRange(obj)
#			print(path)
		else:
			var obj=get_parent().get_node("Enj")

			ObjectEnteredDetectionRange(obj)

	
	
func onShooting():
	
	if !target:
		state= SEARCHING
		return
		
	if  target.position.distance_to(position)> shootingRange :
		state = SEARCHING
		return
		
		
	print("shooting")
	print("Current path : ",path)
	
	pass




func _physics_process(delta):
	


	match state:
		
		DISABLED:
			pass
#		SHOOTING:
#		#WRITE SHOOTING SCRIPT
#			onShooting()
#			pass
		SEARCHING:
		# WRITE SEARCHING SCRIPT
			onSearching()
		
			pass

	
	pass


func _on_shooting_timer_timeout():
	if name.find("En")>=0 :
		print("Shooting as AI")
	else:
		print("Shooting as mini AI")
	

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

		myRocket.position = $rocketAimingPoint.global_position + Vector3(3,3,3)
		myRocket.target = target.position
		
		get_parent().add_child(myRocket)
#		print(target)
		(myRocket as CharacterBody3D).look_at(target.position)
		
		pass
	if target.position.distance_to(position) <= shootingRange:
		$shootingTimer.start()
	else :
		state= SEARCHING
		
	pass # Replace with function body.


func _ObjectEnteredDetectionRange(body):
#	print("Happened from here")
	ObjectEnteredDetectionRange(body)
	pass # Replace with function body.
