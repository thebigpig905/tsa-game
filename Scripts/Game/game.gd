extends Control
var paused: bool = false
var lvlSize: Vector2
var levels = []
@onready var time: Label = $Time
var started = false
var finished = false
var round:int = 1
var faded = false

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
		level.connect("die" , Callable(self , "_on_die"))
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
	$Countdown.play()
	await $Start.timeout
	$Countdown.stop()
	$waterish.play()
	$FloatingCat.play()
	$FloatingCat/fade.play("FadeIn")
	faded = false
	
	$End.start()
	started = true

func _process(delta: float) -> void:
	if started:
		if floor($End.time_left) == 25 and not $"ending soon".playing:
			$"ending soon".play()
		if floor($End.time_left) == 25 and $FloatingCat.playing and !faded:
			$FloatingCat/fade.play("FadeOut")
			faded = true
			
			
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
				$End.paused = false
				if get_child(-1).name == "Menu":
					var remove = get_child(-1)
					remove_child(remove)
					remove.queue_free()
			else:
				paused = true
				$End.paused = true
				var menu = Global.menu.instantiate()
				menu.type = "playing"
				add_child(menu)
	


func _on_end_timeout() -> void:
	finished = true
	paused = true
	$Final.play()
	
	
	add_child(Global.endScreen.instantiate())

func _on_die(lvl):
	print("die")
