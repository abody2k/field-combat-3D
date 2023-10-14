extends "res://scripts/AI.gd"


const SPEED = 10
##the tank movement is different because it needs to go in a circular path if it wants to rotate
@export var v : Vector3
var firstDeg

func _ready():
	pass
	firstDeg=rotation.z
	target = get_parent_node_3d().get_node("target")
	print(deg_to_rad(0))
#	firstDeg= basis.z
#	basis = Basis(Vector3.UP,deg_to_rad(190))


var stop =false
func move(delta : float =0):
	
	print(rad_to_deg(position.angle_to(target.position)))
	if rad_to_deg(position.angle_to(target.position)) > 1 :
		basis = Basis(Vector3.UP,(lerp(position.angle_to(target.position),0.0,delta*30)))
	else :
		stop = true
	pass
var x = 0.0
@export var anglee : float
func _physics_process(delta):
	if not stop:
		move(delta)
	velocity = basis.x * SPEED
	move_and_slide()
#	$MeshInstance3D.basis = Basis(Vector3.UP,deg_to_rad(anglee))
	pass
