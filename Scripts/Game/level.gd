extends Control
var loaded: int
var lvlsize: Vector2
var playing = false
@onready var player = $SubViewportContainer/SubViewport/Player
@onready var ptimer = $SubViewportContainer/SubViewport/Player/Timer
@onready var background = $SubViewportContainer/SubViewport/Background
@onready var cam: Camera2D = $SubViewportContainer/SubViewport/Camera2D
@onready var left: StaticBody2D = $SubViewportContainer/SubViewport/Left
@onready var right: StaticBody2D = $SubViewportContainer/SubViewport/Right
@onready var top: StaticBody2D = $SubViewportContainer/SubViewport/Top
@onready var bottom: StaticBody2D = $SubViewportContainer/SubViewport/Bottom
var prev:Vector2 = Vector2(1 , 1)
var level:int = 0
var fish_left:int = 0

var len = 1000
var maxY:int

var fishes = []
var sheilded:bool = false
var hp:int


func _ready() -> void:
	player.plr = loaded
	hp = Global.settings["lives"]
	background.color = Color.TEAL
	background.size.x = size.x
	background.size.y = len + (len * ((Global.settings["length"] - 1) / 2.0)) #base length + half of length level
	maxY = background.size.y
	lvlsize = size
	player.position.x = size.x / 2
	$SubViewportContainer.size = lvlsize
	$SubViewportContainer/SubViewport.size = lvlsize
	cam.position.x = $SubViewportContainer.size.x / 2
	left.scale.y = maxY / 5
	left.position.x = 2
	left.position.y = (maxY / 2) - 150
	right.scale.y = maxY / 5
	right.position.x = lvlsize.x - 2
	right.position.y = (maxY / 2) - 150
	top.scale.x = lvlsize.x / 10
	top.position.x = lvlsize.x / 2
	top.position.y = -5
	bottom.scale.x = lvlsize.x / 10
	bottom.position.x = lvlsize.x / 2
	bottom.position.y = background.size.y + 5
	create_fishes(true)
	if Global.players < 3:
		level = 1
		create_fishes(false)
	await get_parent().get_child(0).timeout
	playing = true
	player.dir = Vector2(1 , 1)
	cam.limit_bottom = maxY
	

func _process(delta: float) -> void:
	$sheild.visible = sheilded
	if get_parent().paused == true:
		player.p = 0
		for i in fishes:
			i.p = 0
	else:
		player.p = 1
		for i in fishes:
			i.p = 1
	cam.position.y = player.position.y
	if player.position.x >= lvlsize.x - (player.size.x / 2) - 2:
		player.dir.x = -1
	if player.position.x <= player.size.x / 2 + 2:
		player.dir.x = 1
	if player.position.y >= maxY - (player.size.y / 2):
		if player.dir.y == 2:
			player.dir.x = prev.x
		player.dir.y = -1
	if player.position.y <= 0 + (player.size.y / 2):
		player.ext = Vector2(1 , 1)
		player.scale = Vector2(1 , 1)
		player.dir.y = 1
		var score = Global.score.instantiate()
		if $FrenzyTimer.time_left != 0:
			Global.scores[loaded] += player.held * 150
			score.t = "+" + str(player.held * 150)
			score.g = true
		else:
			Global.scores[loaded] += player.held * 100
			score.t = "+" + str(player.held * 100)
		
		score.position = Vector2((size.x / 2) - (score.size.x / 2), 100)
		if int(score.t) != 0:
			player.get_parent().add_child(score)
		else:
			score.queue_free()
		if fish_left <= Global.settings["weight"] - 1:
			fish_left = 0
			level += 1
			create_fishes(true)
			if Global.players < 3:
				create_fishes(false)
		player.held = 0
	

func _input(event: InputEvent) -> void:
	if playing:
		if event.as_text() == Global.switch[loaded]:
			if event.is_pressed() == true:
				if event.is_echo() == false:
					if ptimer.time_left == 0:
						player.dir *= Vector2(-1 , 1)
						prev = player.dir
						ptimer.start()
					else:
						if player.dir.y > 0:
							player.dir = Vector2(0 , 2)
			else:
				if player.dir == Vector2(0 , 2):
					player.dir = prev
		if event.as_text() == Global.use[loaded]:
			if event.is_pressed() == true:
				if event.is_echo() == false:
					if player.held > 0:
						if player.dir.y == 2:
							player.dir.x = prev.x
						player.dir.y = -1

func create_fishes(remove):
	var skip = false
	if remove:
		for i in $SubViewportContainer/SubViewport.get_children():
			if i.has_method("fish"):
				$SubViewportContainer/SubViewport.remove_child(i)
				i.queue_free()
		fishes.clear()
	for i in (maxY - 200) / 100:
		if randi_range(0 , 3) > 0:
			fish_left += 1
			var newFish = Global.item.instantiate()
			newFish.type = "fish"
			if Global.settings["powerups"] == true:
				if randi_range(1 , 16) == 1:
					newFish.type = "power"
					fish_left -= 1
			newFish.position.x = randi_range(10 , lvlsize.x - 10)
			newFish.position.y = (100 * i) + 200
			for k in fishes:
				if k.position.y == newFish.position.y:
					if abs(k.position.x - newFish.position.x) < 50:
						newFish.queue_free()
						fish_left -= 1
						skip = true
					break
			if !remove:
				if !skip:
					if randi_range(0 , 2) > 0:
						fishes.append(newFish)
					else:
						newFish.queue_free()
						fish_left -= 1
				else:
					skip = false
			else:
				fishes.append(newFish)
	var bad = []
	for i in fishes:
		if i.type == "fish":
			bad.append(i)
	for i in clamp(level , 0 , Global.settings["length"] * 2):
		var rand = randi_range(0 , bad.size() - 1)
		if bad.size() > 0:
			if bad[rand].type != "bad":
				bad[rand].type = "bad"
				bad[rand].upds()
				fish_left -= 1
	for i in fishes:
		$SubViewportContainer/SubViewport.add_child(i)
	for i in level:
		var obs = Global.obs.instantiate()
		obs.position.x = Global.screen.x / Global.players * randi_range(0 , 1)
		if obs.position.x == 0:
			obs.position.x += 50
		else:
			obs.position.x -= 50
		obs.position.y = randi_range(100 , maxY)
		$SubViewportContainer/SubViewport.add_child(obs)


func _on_player_power(type: Variant) -> void:
	match type:
		"sheild":
			sheilded = true
		"pslow":
			for i in get_parent().get_child_count():
				if get_parent().get_child(i).has_method("_on_player_power"):
					if get_parent().get_child(i) != self:
						if get_parent().get_child(i).sheilded == false:
							get_parent().get_child(i).player.ext = Vector2(0.5 , 1)
						else:
							get_parent().get_child(i).sheilded = false
		"pfast":
			for i in get_parent().get_child_count():
				if get_parent().get_child(i).has_method("_on_player_power"):
					if get_parent().get_child(i) != self:
						if get_parent().get_child(i).sheilded == false:
							for k in get_parent().get_child(i).get_child(0).get_child(0).get_children():
								if k.has_method("fish"):
									if k.type != "power":
										k.speed = randi_range(175 , 300)
						else:
							get_parent().get_child(i).sheilded = false
		"bonus":
			Global.scores[loaded] += 50
			var score = Global.score.instantiate()
			score.t = "+50"
			score.position = player.position
			player.get_parent().add_child(score)
		"size":
			player.scale = Vector2(2 , 2)
		"frenzy":
			$FrenzyTimer.start()
			player.frenzy = true
		"trash1":
			if sheilded:
				sheilded = false
			else:
				Global.scores[loaded] -= 50
				_on_player_damaged()
				var score = Global.score.instantiate()
				score.t = "-50"
				score.g = false
				score.position = player.position
				player.get_parent().add_child(score)
		"trash2":
			if sheilded:
				sheilded = false
			else:
				Global.scores[loaded] -= 50
				_on_player_damaged()
				var score = Global.score.instantiate()
				score.t = "-50"
				score.g = false
				score.position = player.position
				player.get_parent().add_child(score)


func _on_player_damaged() -> void:
	hp -= 1
	var score = Global.score.instantiate()
	score.t = "-1 HP"
	score.g = false
	score.position = player.position + Vector2(0 , 24)
	player.get_parent().add_child(score)
	if hp <= 0:
		level = 0
		fish_left = 0
		Global.scores[loaded] -= abs(Global.scores[loaded] / 2)
		if Global.scores[loaded] % 10 != 0:
			Global.scores[loaded] -= 25
		player.position.x = size.x / 2
		player.position.y = 10
		hp = Global.settings["lives"]
		create_fishes(true)
		if Global.players < 3:
			create_fishes(false)
