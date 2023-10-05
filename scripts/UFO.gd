extends CharacterBody3D



@export var speed : float
var readyToAttack=true
var state=IDLE
enum {IDLE,ABSROBING}
var absorbObj : CharacterBody3D
var absorbOnjPos = Vector3.ZERO
var rocket = preload("res://rocket.tscn")
var velo = Vector3.ZERO

func _ready():
	$AnimationPlayer.play("rotation")
	pass
	
func attacking():
	if Input.is_action_just_pressed("attack") and readyToAttack:
		var tempRocket = rocket.instantiate()
		tempRocket.target=$target.global_position
		tempRocket.position = position + Vector3.DOWN * 3
		get_parent().add_child(tempRocket)
		readyToAttack=false
		$reloading.start()
			
func movement():
	
	velo.x=-Input.get_axis("moveUP","moveDOWN")
	velo.z=Input.get_axis("moveLEFT","moveRIGHT")

	velocity = velo * speed 
	move_and_slide()
	
func absorbing():
	if Input.is_action_just_pressed("absorb") and state != ABSROBING:
		$emiting.start()
		state=ABSROBING
		#make rings
		$rings.emitting=true
		$rings2.emitting=true		
		
		#check if there is at least one object or more at that place
		if $checker.is_colliding():
			print("COLLIDING")
			var collidedObj=$checker.get_collider()
			#if there is then check if they are the enemy then freeze them
			print(collidedObj.name)
			if collidedObj is CharacterBody3D:
				print(collidedObj)
				if collidedObj.name.find("En") >=0:
					collidedObj.freezeMe()
					absorbObj=collidedObj
					print("did set location an object",absorbObj,absorbObj.position)
					absorbOnjPos = absorbObj.position
					var x = create_tween()
					x.tween_property(absorbObj,"position",position,1)
#					x.tween_property(absorbObj,"position",position - Vector3(0,2,0),1)
					x.tween_callback(func (): print("Done"))
					x.play()
			#if not animate absorbing for only 1 second
			pass
		
		
		#after freezing them disable their physics
		#move them towards the UFO
		#when they are undreneath it they will be abosrbed up in one second
		#then they are destroyed
		
		
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
		
		
	
func _physics_process(delta):
	match state:
		IDLE:
			movement()
			attacking()
			absorbing()
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
