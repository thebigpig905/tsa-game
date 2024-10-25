extends CenterContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	size.x = Global.screen.x
	for i in Global.players:
		var info = Global.info.instantiate()
		info.plr = i
		info.size.x = Global.screen.x/ Global.players
		info.size.y = size.y
		$HBoxContainer.add_child(info)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
