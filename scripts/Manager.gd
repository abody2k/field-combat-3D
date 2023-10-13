extends Node



var maximumScore : float = randi_range(0,999999)
var currentScore : float 
func save():
	
	maximumScore= randi_range(0,999999)
	return {
		
		
		
		"ms":maximumScore,
		
	}
	
	
func saveProgress():
	
	var file=FileAccess.open("user://savegame.save",FileAccess.WRITE)
	file.store_line(JSON.stringify(save()))
	print("Data is stored")
	$HTTPRequest.request("http://localhost:3000/sd",["Content-Type: Application/json"],HTTPClient.METHOD_POST,JSON.stringify(save()))

func loadProgress():
	if not FileAccess.file_exists("user://savegame.save"):
		print("No such file")
		return
	var file = FileAccess.open("user://savegame.save",FileAccess.READ)
	
	var json = JSON.new()
	json.parse(file.get_line())
	print(json.get_data())
	
	pass
	
