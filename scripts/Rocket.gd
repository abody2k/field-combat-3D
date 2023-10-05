extends CharacterBody3D


@export var rocketSpeed : float
var target : Vector3


#Write down the rocket forumla

func _physics_process(delta):
	

	velocity=((target- position)* rocketSpeed)
	var result = null

	if move_and_slide():
		result = get_last_slide_collision().get_collider()
		#result.get_collider()
	if result is CharacterBody3D :

		

		if result.name.find("Rocket")<0:
			queue_free()
		else:
			result.queue_free()
			queue_free()
			
	elif result != null:
#		print(result)
		queue_free()
