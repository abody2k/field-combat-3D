extends CharacterBody3D


@export var target : Node3D
@export var forwardDirection : Vector3
@export var speed : float = 10.0
@export var shootingRange : float = 20.0
enum  {SEARCHING, SHOOTING}
var path : PackedVector2Array
var state = 0

#run this func when target is null to go search for enemies
func lookForEnemies():
	velocity= forwardDirection * speed
	move_and_slide()
	pass


func ObjectEnteredDetectionRange(body):
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



## this function is used when the AI is searching for an enemy
func onSearching():
	
	
	pass
	
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
