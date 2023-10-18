extends Node3D


@export var gridWidth : int =1
@export var gridHeight : int =1
@export var gridRectSize : Vector2i =Vector2i(1,1)
const block = preload("res://scenes/barrier.tscn")
const UFO = preload("res://scenes/en_ufo.tscn")
enum UNITS {SOLIDER,TANK,HELICOPTER}
var currentUFO 
var grid = AStarGrid2D.new()

var destroyedUnits =[]
##called whenever a unit is destroyed
func unitDestroyed(unitName : String,team : int):
	destroyedUnits.append({team:unitName})
	makeNewUnit()
	
	#calls the AI to check
	pass

func getPositionListGivenPosition(start: Vector2, end :Vector2):
#	print(position)

	var tempStart = Vector2i(ceil((start.x-position.x)/gridRectSize.x),ceil((start.y-position.y)/gridRectSize.y))
	var tempEnd = Vector2i(ceil((end.x-position.x)/gridRectSize.x),ceil((end.y-position.y)/gridRectSize.y))
#	print(tempStart,tempEnd)
	return grid.get_point_path(tempStart,tempEnd)
	
func get_stats():
	return destroyedUnits	

func _ready():
	
	grid.region= Rect2(position.x as int,position.y as int,gridWidth,gridHeight)
	grid.cell_size=gridRectSize
	grid.offset= Vector2(0.1,0.1)
	grid.jumping_enabled=true
	grid.update()
	generate_map()
	grid.update()
#	grid.set_point_solid(Vector2i(3,3))	

	
	pass



func _on_ufo_en_timeout():
	#create a UFO and send it
	if not is_instance_valid(currentUFO):
		#make a new UFO
		currentUFO = UFO.instantiate()
		add_child(currentUFO)
		currentUFO.position = $finishingPoint.position- Vector3(10,-3,10)
		currentUFO.name+="_En_UFO"
		currentUFO.team=1
		
		pass
	pass # Replace with function body.


func generate_map():
	for child in get_children() :
		if child is StaticBody3D and child.name.find("barrier")>=0:
			
			grid.set_point_solid(Vector2i(ceil(child.position.x) as int,ceil(child.position.z) as int))
			pass
		pass
		
	return
	randomize()
	
	for i in range (gridWidth/10):
		for j in range (gridHeight/10):
			if randi()%10 ==0:
				var barrier = block.instantiate()
				barrier.position=Vector3(i,0,j)
				add_child(barrier)
				grid.set_point_solid(Vector2i(i,j))
				
				
	pass




func makeNewUnit():
	
#	var unit = load("res://scenes/"+UNITS.keys()[randi_range(0,2)].to_lower()+".tscn")
	var unit = load("res://scenes/tank.tscn")
	var createdUnit = unit.instantiate()

	
	add_child(createdUnit)
	createdUnit.name+="_En"
	createdUnit.position = $finishingPoint.position + Vector3(0,0,randf_range(-20,20))
	createdUnit.team =1	
	pass


func _on_units_creator_timeout():
	makeNewUnit()
	pass # Replace with function body.
