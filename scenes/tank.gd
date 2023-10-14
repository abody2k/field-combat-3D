extends "res://scripts/AI.gd"


const SPEED = 30
##the tank movement is different because it needs to go in a circular path if it wants to rotate
@export var v : Vector3
var firstDeg

func _ready():
	pass
#	target = get_parent_node_3d().get_node("target")
#	firstDeg= basis.z
#	basis = Basis(Vector3.UP,deg_to_rad(190))



func move(delta : float =0):
	basis = Basis(Vector3.UP,(lerp(0.0,position.angle_to(target.position),delta)))
	
	pass

@export var anglee : float
func _physics_process(delta):

#	$MeshInstance3D.basis = Basis(Vector3.UP,deg_to_rad(anglee))
	pass
