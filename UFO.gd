extends CharacterBody3D



@export var speed : float
var readyToAttack=true
var state=IDLE
enum {IDLE,ABSROBING}

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
	print(velo)
	velocity = velo * speed 
	move_and_slide()
	
func absorbing():
	if Input.is_action_just_pressed("absorb") and state != ABSROBING:
		$emiting.start()
		state=ABSROBING
		$rings.emitting=true
		$rings2.emitting=true		
		#make rings
		#check if there is at least one object or more at that place
		#if there is then check if they are the enemy then freeze them
		#if not animate absorbing for only 1 second
		#after freezing them disable their physics
		#move them towards the UFO
		#when they are undreneath it they will be abosrbed up in one second
		#then they are destroyed
		
		

func _physics_process(delta):
	match state:
		IDLE:
			movement()
			attacking()
			absorbing()
		ABSROBING:
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
