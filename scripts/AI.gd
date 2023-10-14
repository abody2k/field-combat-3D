extends CharacterBody3D


@export var target : Node3D
@export var forwardDirection : Vector3
@export var speed : float = 10.0
@export var shootingRange : float = 20.0
enum  {SEARCHING, SHOOTING,DISABLED}
var path : PackedVector2Array
var state = 0

#run this func when target is null to go search for enemies
func lookForEnemies():
	velocity= forwardDirection * speed
	move_and_slide()
	pass

func freezeMe():
	print("I'M SO FREEZED !")
	($enemeyDetector as Area3D).monitoring=false
	($solidoundary as CollisionShape3D).disabled=true
	state=DISABLED
#	process_mode=Node.PROCESS_MODE_DISABLED
	
func unFreezeMe():
	state=SEARCHING
	($enemeyDetector as Area3D).monitoring=true
	($solidoundary as CollisionShape3D).disabled=false
#	process_mode = PROCESS_MODE_PAUSABLE
	

func ObjectEnteredDetectionRange(body):
	if state == DISABLED:
		return
	# Detect if the object is a real thing or not 
	if !((body) is CharacterBody3D) and !(body is Node3D ):
		return
	# Detect if the object is an  ally
	print("Arrived here")
	print(body.name)

	if (body.name!="Enj" and body.name!="j"):
		print("undergo")
		if ((body.name as String).find("En") == -1 and name.find("En")==-1)or ((body.name as String).find("En") != -1 and name.find("En")!=-1 ):
			return
	print("passed")
	print(body.name ,name)
	state=SEARCHING
	target = body
	print("Collision happened")
	print(body.position)
	print(position)
	path=get_parent().getPositionListGivenPosition(Vector2(position.x,position.z),Vector2((body as Node3D).position.x,(body as Node3D).position.z))
	pass # Replace with function body.



#applies the movement to the unit, a movement for a unit is far different from a tank and so on
func move(delta : float =0):
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
			onSearching(delta)
		
			pass
			
##a a function that is called when a target is detected passing the target throgh it
func addFind(obj : Node3D):
	pass	
## this function is used when the AI is searching for an enemy
#checks if there is a player or not,if there is and in range it attacks if not it moves
#towards it and if there is no player it looks for the final point to go to
func onSearching(delta ):
	
	
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

			move(delta )
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
			addFind(obj)

			ObjectEnteredDetectionRange(obj)
#			print(path)
		else:
			var obj=get_parent().get_node("Enj")
			addFind(obj)
			ObjectEnteredDetectionRange(obj)
	
## this function is used to stop the AI and start shooting
func onShooting():
	
	pass

func _on_timer_timeout():
	print("I'm checking if the target is alright")
	if !target:
		$Timer.stop()
		state = SEARCHING
		
	else:
		path=get_parent().getPositionListGivenPosition(position,target.position)	
		print("DISTANCE = ",Vector2(position.x,position.z).distance_to(Vector2(target.position.x,target.position.z)))
		if 	Vector2(position.x,position.z).distance_to(Vector2(target.position.x,target.position.z)) <= shootingRange:
			#shooting mode	
			state = SHOOTING
		$Timer.start()
	
	pass # Replace with function body.
