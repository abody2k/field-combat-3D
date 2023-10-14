extends Node3D


@export var gridWidth : int =1
@export var gridHeight : int =1
@export var gridRectSize : Vector2i =Vector2i(1,1)

var grid = AStarGrid2D.new()


func getPositionListGivenPosition(start: Vector2, end :Vector2):
#	print(position)

	var tempStart = Vector2i(ceil((start.x-position.x)/gridRectSize.x),ceil((start.y-position.y)/gridRectSize.y))
	var tempEnd = Vector2i(ceil((end.x-position.x)/gridRectSize.x),ceil((end.y-position.y)/gridRectSize.y))
#	print(tempStart,tempEnd)
	return grid.get_point_path(tempStart,tempEnd)
	
	

func _ready():

	grid.size= Vector2i(gridWidth,gridHeight)
	grid.cell_size=gridRectSize
	grid.update()
	
	grid.set_point_solid(Vector2i(3,3))	

	
	pass

