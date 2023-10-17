extends CharacterBody3D


@export var target : Node3D
@export var forwardDirection : Vector3
@export var speed : float = 10.0
var tempSpeed=0.0
@export var shootingRange : float = 20.0
enum  {SEARCHING,AIMING, SHOOTING,RETREATING,DISABLED}
enum  TEAM {BLUE,RED}
var team
var path : PackedVector2Array
var state = 0
var finishedAiming : bool = false
var freezed = false
## a function that makes the unit goes to the winner new side
func disable_me():
	($enemeyDetector as Area3D).monitoring = false
	var x = Node3D.new()
	get_parent().add_child(x)
	x.position=get_parent().get_node("finishingPoint").position + Vector3( randf_range(20,70),0,randf_range(20,70))
	target = x
	pass
	


	
func slowMeDown():
	tempSpeed = speed
	speed = speed/2
	pass
	
func moveFaster():
	
	speed = tempSpeed
##used by flying objects
func choosingTeam():
	
	if name.find("En") >=0 :
		team = TEAM.RED
	else :
		team = TEAM.BLUE
		

func flyAround(delta : float):
	pass
#run this func when target is null to go search for enemies
func lookForEnemies():
	velocity= forwardDirection * speed
	move_and_slide()
	pass

func _ready():
	choosingTeam()
func freezeMe():
	freezed=true
	($enemeyDetector as Area3D).monitoring=false
	($solidoundary as CollisionShape3D).disabled=true
	state=DISABLED
#	process_mode=Node.PROCESS_MODE_DISABLED
	
func unFreezeMe():
	print("IM BEING UNREEZED")
	freezed=false
	state=SEARCHING
	target=null
	($enemeyDetector as Area3D).monitoring=true
	($solidoundary as CollisionShape3D).disabled=false
	position = Vector3(position.x,0,position.z)
#	process_mode = PROCESS_MODE_PAUSABLE
	

func ObjectEnteredDetectionRange(body):
	if freezed:
		return
		
	if state == DISABLED:
		return
	# Detect if the object is a real thing or not 
	if !((body) is CharacterBody3D) and !(body is Node3D ):
		return
	# Detect if the object is an  ally

	if body is StaticBody3D:
		return
	
	if ("team" in body):
		if team == body.team:
			return
			

#	if (body.name!="Enj" and body.name!="j"):
#
#		if ((body.name as String).find("En") == -1 and name.find("En")==-1)or ((body.name as String).find("En") != -1 and name.find("En")!=-1 ):
#			return

	if state == DISABLED:
		return
	state=SEARCHING
	target = body

	path=get_parent().getPositionListGivenPosition(Vector2(position.x,position.z),Vector2((body as Node3D).position.x,(body as Node3D).position.z))
	pass # Replace with function body.



#applies the movement to the unit, a movement for a unit is far different from a tank and so on
func move(delta : float =0):
	pass

## called when an object is about to attack, it aims first then it attacks 
func aiming(delta : float):
	pass
	
func _physics_process(delta):
	


	match state:
		
		DISABLED:
			return
		AIMING:
			flyAround(delta)
			aiming(delta)
#		#WRITE SHOOTING SCRIPT
#			onShooting()
#			pass
		SEARCHING:
		# WRITE SEARCHING SCRIPT
			onSearching(delta)
		
		RETREATING:
			#make it go home
			look_at(Vector3(get_parent().get_node("finishingPoint").position.x,position.y,get_parent().get_node("finishingPoint").position.z))
			velocity = (-basis.z) 
			move_and_slide()
			
			pass
		
		
			pass
			
##a a function that is called when a target is detected passing the target throgh it
func addFind(obj : Node3D):
	pass	
## this function is used when the AI is searching for an enemy
#checks if there is a player or not,if there is and in range it attacks if not it moves
#towards it and if there is no player it looks for the final point to go to
func attack():
	pass
func onSearching(delta ):
	
	
#	print("Searching")
	if is_instance_valid(target) :
	
#		print("I'm",name," and my enemy is",target.name)
		if target.position.distance_to(position) <= shootingRange:

			
			
			state=AIMING
			

		else :
			if path.size()<1 :
				return
#			if target.name=="j":


			move(delta )

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

	if !target:
		$Timer.stop()
		state = SEARCHING
		
	else:
		path=get_parent().getPositionListGivenPosition(position,target.position)	

		if 	Vector2(position.x,position.z).distance_to(Vector2(target.position.x,target.position.z)) <= shootingRange:
			#shooting mode	
			state = SHOOTING
		$Timer.start()
	
	pass # Replace with function body.
