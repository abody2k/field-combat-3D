extends Node3D

var targets = []
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
enum MODES {WAITING,AIMING,ATTACKING}
var current_mode = MODES.WAITING

func aiming(delta : float =0):
	if targets[0] !=null :
		pass
		
	var direction: Vector3 = targets[0].position- position
	$cannon.basis = $cannon.basis.slerp(Basis.looking_at(direction),delta)
	if (direction.normalized().dot($canon.basis.z)) >= 0.9:
		current_mode=MODES.ATTACKING
	
	
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match current_mode :
		MODES.WAITING:
			pass
		MODES.AIMING:
			aiming(delta)
			pass
		MODES.ATTACKING:
			pass
	pass


func _on_area_3d_body_shape_entered(_body_rid, body, _body_shape_index, _local_shape_index):
	if body is RigidBody3D and (body.name as String).find("En")<0 :
		#they caough us
		targets.append(body)
		current_mode= MODES.AIMING
		pass
	pass # Replace with function body.


func _on_area_3d_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	pass # Replace with function body.
