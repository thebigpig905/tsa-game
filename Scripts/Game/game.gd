extends Control
var paused: bool = false
var lvlSize: Vector2
var levels = []
@onready var time: Label = $Time
var started = false
var finished = false
var round:int = 1

func _ready() -> void:
	time.size.x = Global.screen.x
	time.position.y = 20
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
	if Global.settings["timer"] / 60 != 0:
		time.text = str(Global.settings["timer"] / 60) + ":"
	else:
		time.text = ""
	if Global.settings["timer"] % 60 < 10:
		time.text += "0" + str(Global.settings["timer"] % 60)
	else:
		time.text += str(Global.settings["timer"] % 60)
	await $Start.timeout
	$End.start()
	started = true

func _process(delta: float) -> void:
	if started:
		if floor($End.time_left / 60) != 0:
			time.text = str(floor($End.time_left / 60)) + ":"
		else:
			time.text = ""
		if floori($End.time_left) % 60 < 10:
			time.text += "0" + str(floori($End.time_left) % 60)
		else:
			time.text += str(floori($End.time_left) % 60)
	if !finished:
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
	


func _on_end_timeout() -> void:
	finished = true
	paused = true
	add_child(Global.endScreen.instantiate())
