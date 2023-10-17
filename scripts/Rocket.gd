extends CharacterBody3D


@export var rocketSpeed : float
var target : Vector3

#attack only enemy
var myTeam = 0
#Write down the rocket forumla

func _physics_process(delta):
	

	velocity=((target- position)* rocketSpeed)
	
	var result = null

	if move_and_slide():
		result = get_last_slide_collision().get_collider()
		#result.get_collider()
	if result is CharacterBody3D :

		print(result.name)

		if result.name.find("Rocket")>=0:
			
			queue_free()
		else:
			if result.team == myTeam:
				print("friendly fire")
				queue_free()
				return
				
			result.queue_free()
			queue_free()
			
	elif result != null:
#		print(result)
		queue_free()
	if position.distance_squared_to(target) <=1 :
		queue_free()


func _on_timer_timeout():
	queue_free()
	pass # Replace with function body.
