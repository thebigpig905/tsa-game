extends Control
var paused: bool = false
var lvlSize: Vector2

func _ready() -> void:
	lvlSize = Global.screen / Vector2(Global.players , 1)
	lvlSize.y *= 0.85
	for i in Global.players:
		var level = Global.level.instantiate()
		level.loaded = i
		level.position.x = lvlSize.x * i
		level.size = lvlSize
		add_child(level)
	$Start.start()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("esc"):
		if paused:
			paused = false
			if get_child(-1).name == "Menu":
				var remove = get_child(-1)
				remove_child(remove)
				remove.queue_free()
		else:
			paused = true
			var menu = Global.menu.instantiate()
			menu.type = "playing"
			add_child(menu)
