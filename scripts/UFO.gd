extends CharacterBody3D



@export var speed : float
var readyToAttack=true
var state=IDLE
enum {IDLE,ABSROBING}
enum UNITS {SOLIDER,TANK,HELICOPTER}
var absorbObj : CharacterBody3D
var absorbOnjPos = Vector3.ZERO
var rocket = preload("res://scenes/rocket.tscn")
var team =0
var velo = Vector3.ZERO
var pressingTime: float
var currentUnit = UNITS.SOLIDER
var tempSpeed : float = 0.0

func slowMeDown():
	tempSpeed = speed
	speed = speed/2
	pass
	
func moveFaster():
	
	speed = tempSpeed





func _ready():
	$AnimationPlayer.play("rotation")
	pass
	
func attacking():
	if Input.is_action_just_pressed("attack") and readyToAttack:
		var arr =[]
		for i in range(2) :
			var tempRocket = rocket.instantiate()
			tempRocket.target=$target.global_position
			tempRocket.position = $emit.global_position
			arr.append(tempRocket)
		
			tempRocket.rotation = $emit.rotation
		get_parent().add_child(arr[0])
		arr[1].rotation_degrees.x=0
		
		get_parent().add_child(arr[1])
		
#		tempRocket.look_at($checker.target_position+position,Vector3.UP,true)
		readyToAttack=false
		$reloading.start()
			
func movement():
	
	velo.x=-Input.get_axis("moveUP","moveDOWN")
	velo.z=Input.get_axis("moveLEFT","moveRIGHT")
	if velo != Vector3.ZERO:

#		print((pressingTime - Time.get_ticks_msec())/1000.0)
		if ( Time.get_ticks_msec()-pressingTime)/1000.0 >= 0.5:
			pressingTime=0
			switchingUnits()
		elif pressingTime == 0 :
			pressingTime = 	 Time.get_ticks_msec()

		
	velocity = velo * speed 
	move_and_slide()
	
func switchingUnits():

	#Check the current index if it's the last one then move it back to 0
	
	if currentUnit == UNITS.HELICOPTER :
		currentUnit = UNITS.SOLIDER
	else :
		currentUnit+=1
	#change Image acording to the current Index
#	(get_parent().get_node("CanvasLayer/Control/img") as TextureRect).modulate =Color(randi_range(0,140),0,0)
#	(get_parent().get_node("CanvasLayer/Control/img") as TextureRect).texture = load("res://assets/"+str(currentUnit))
	
func absorbing():
	if Input.is_action_just_pressed("absorb") and state != ABSROBING:
		$emiting.start()
		state=ABSROBING
		#make rings
		$rings.emitting=true
		$rings2.emitting=true		
		
		#check if there is at least one object or more at that place
		if $checker.is_colliding():

			var collidedObj=$checker.get_collider()
			#if there is then check if they are the enemy then freeze them

			if collidedObj is CharacterBody3D:

				if collidedObj.name.find("En") >=0:
					if not collidedObj.has_method("freezeMe"):
						return
					collidedObj.freezeMe()
					absorbObj=collidedObj

					absorbOnjPos = absorbObj.position
					var x = create_tween()
					x.tween_property(absorbObj,"position",position,1)
#					x.tween_property(absorbObj,"position",position - Vector3(0,2,0),1)
					x.tween_callback(fromGroundToUFO)
					x.play()
			#if not animate absorbing for only 1 second
			pass
		
		
		#after freezing them disable their physics
		#move them towards the UFO
		#when they are undreneath it they will be abosrbed up in one second
		#then they are destroyed
		
		
func fromGroundToUFO():
	var x = create_tween()
	x.tween_property(absorbObj,"position",position,0.5)
	x.tween_callback(func(): absorbObj.queue_free())
	pass
#func suckingObject(delta):
#	print("Checking something here",absorbObj)
#	if absorbObj != null and !is_instance_valid(absorbObj):
#		return
#	if absorbObj == null:
#		return
#
#	print("bringing it")
#	var x =Tween.new()
#
#	absorbObj.position = lerp(absorbOnjPos,position,)
#	if absorbObj.position.distance_squared_to(position) <= 0.05:
#		absorbObj.queue_free()
#		absorbObj=null
		
		
func spawning():
	
	if Input.is_action_just_pressed("spawn"):
		pass
		#load unit from res
		#give it a random position
		#
		
		var unit = load("res://scenes/"+str(UNITS.keys()[currentUnit]).to_lower()+".tscn")
		var nunit=unit.instantiate()
		get_parent().add_child(nunit)
		nunit.position = get_parent().position + Vector3(1,0,0.05) * randi_range(0,10)
		
		
		
	pass
func _physics_process(delta):
	
	if Input.is_key_pressed(KEY_L):
		get_tree().get_first_node_in_group("manager").call("loadProgress")
	if Input.is_key_pressed(KEY_S):
		get_tree().get_first_node_in_group("manager").call("saveProgress")
		
	match state:
		IDLE:
			movement()
			attacking()
			absorbing()
			spawning()
		ABSROBING:
#			suckingObject(delta)
			pass
	

	
	pass


func _on_reloading_timeout():
	readyToAttack=true
	pass # Replace with function body.


func _on_emiting_timeout():
	$rings.emitting=false
	$rings2.emitting=false
	state=IDLE
	pass # Replace with function body.

#UFO died
func _on_tree_exiting():
	#set the unit back to its position and unfreeze it
	if is_instance_valid(absorbObj):
		absorbObj.position= absorbOnjPos
		absorbObj.unFreezeMe()
		
	
	
	pass # Replace with function body.
