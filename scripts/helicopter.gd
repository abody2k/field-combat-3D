extends "res://scripts/AI.gd"

var counter : float =0.0
@export var radius : float =1.0
var forward : Vector3 = Vector3.UP * -100
@export var temporal = 0.0
var switched=false
const DIAGNOAL : float = 7.0
var fliper =0
const rocket = preload("res://scenes/rocket.tscn")
##moves toward an object
func moveInto(delta : float ):
	look_at(Vector3(target.position.x,3,target.position.z))
	if switched:
		if position.distance_squared_to(target.position+ Vector3(DIAGNOAL,0,DIAGNOAL)) < 1 :
			attack()
			switched=false
			fliper+=1
		velocity = (target.position+ Vector3(DIAGNOAL,0,DIAGNOAL)) - position

		move_and_slide()
	else:

		if position.distance_squared_to(target.position+ Vector3(-DIAGNOAL,0,-DIAGNOAL)) < 1:
			attack()
			switched=true
			fliper+=1
		velocity = (target.position+ Vector3(-DIAGNOAL,0,-DIAGNOAL)) - position
		move_and_slide()
	
	pass
func flyAround(delta : float):
	

	if target.position.y >=3 and fliper <3:
		moveInto(delta)
		return
	look_at(Vector3(target.position.x,3,target.position.z))		

	counter += delta
	position+= Vector3(cos(((counter))),0,sin((counter))) * radius * delta

	if counter >=2:
		fliper=0
		counter=0
		switched=false
		print("reseted fliper")
		attack()

	# if the target is not on ground then move directly into them

func move(delta : float=0):

	velocity = speed * (target.position-position)
	look_at(Vector3(target.position.x,3,target.position.z))
	move_and_slide()
	pass

func attack():
	#create rocket
	#make it go to the target
	#restart the timer
	var myRocket = rocket.instantiate()
	
	myRocket.position = $aim.global_position 
	myRocket.target = target.position
	myRocket.myTeam = team
	myRocket.rocketSpeed = 10
	get_parent().add_child(myRocket)
	(myRocket as CharacterBody3D).look_at(target.position)
	state = SEARCHING	
	pass
