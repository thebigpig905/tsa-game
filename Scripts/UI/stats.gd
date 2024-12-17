extends CenterContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#make a score row for each player
	size.x = Global.screen.x
	for i in Global.players:
		var info = Global.info.instantiate()
		info.plr = i
		info.size.x = Global.screen.x/ Global.players
		info.size.y = size.y
		$HBoxContainer.add_child(info)
