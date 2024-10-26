extends Control
var paused: bool = false
var lvlSize: Vector2
var levels = []

func _ready() -> void:
	Global.scores = []
	lvlSize = Global.screen / Vector2(Global.players , 1)
	lvlSize.y *= 0.85
	lvlSize.y = clamp(lvlSize.y , INF , Global.screen.y - 130)
	for i in Global.players:
		var level = Global.level.instantiate()
		level.loaded = i
		level.position.x = lvlSize.x * i
		level.size = lvlSize
		levels.append(level)
		add_child(level)
		Global.scores.append(0)
	var score = Global.stats.instantiate()
	score.size.y = Global.screen.y - lvlSize.y
	score.position.y = Global.screen.y - score.size.y
	add_child(score)
	$Start.start()
	$End.wait_time = Global.settings["timer"]

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
