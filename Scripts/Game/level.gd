extends Control
signal caught(tex)
signal cleared
var loaded: int
var lvlsize: Vector2
var playing = false
var big = false
var fastdown = false
var fastdownp = false
#important nodes
@onready var player = $SubViewportContainer/SubViewport/Player
@onready var ptimer = $SubViewportContainer/SubViewport/Player/Timer
@onready var background = $SubViewportContainer/SubViewport/Background
@onready var cam: Camera2D = $SubViewportContainer/SubViewport/Camera2D
@onready var frenzy = $FrenzyTimer


#walls
@onready var left: StaticBody2D = $SubViewportContainer/SubViewport/Left
@onready var right: StaticBody2D = $SubViewportContainer/SubViewport/Right
@onready var top: StaticBody2D = $SubViewportContainer/SubViewport/Top
@onready var bottom: StaticBody2D = $SubViewportContainer/SubViewport/Bottom

@onready var line: Line2D = $SubViewportContainer/SubViewport/Line2D

#game info
var prev:Vector2 = Vector2(1 , 1) #previous player velocity for switching directions easier
var level:int = 0
var fish_left:int = 0

var len = 1000 #level length 
var maxY:int #level base

var fishes = [] #stores the fishes in here for updating
var sheilded:bool = false #if sheild power is active
var hp:int #player health

#runs on scene load
func _ready() -> void:
	
	player.plr = loaded #sets the players player number to the load order :if this level was loaded first, that is player 1
	hp = Global.settings["lives"] #sets player hp to the global setting
	background.color = Color.TEAL #background color
	background.size.x = size.x #resizes the background to fit the screen
	background.size.y = len + (len * ((Global.settings["length"] - 1) / 2.0)) #base length + half of length level
	maxY = background.size.y #sets the bottom
	lvlsize = size #idk why this is here
	player.position.x = size.x / 2 #sets the player to be in the center of the level
	$SubViewportContainer.size = lvlsize #sets the player view size to match the level size
	$SubViewportContainer/SubViewport.size = lvlsize
	cam.position.x = $SubViewportContainer.size.x / 2 #centers the camera
	$border.size = lvlsize - Vector2(16 , 0)
	
	#resize and set wall positions
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
	
	#set the fishing line
	line.points[0] = Vector2(lvlsize.x / 2 , -500)
	#generate the fishes
	create_fishes(true)
	if Global.players < 3: #if there are less than 3 players, make it a bit harder
		level = 1
		create_fishes(false)
		
	#create background fishes
	for i in randi_range(10 , 20):
		var fish = Global.backgroundfish.instantiate()
		fish.position.y = randi_range(50 , maxY)
		fish.position.x = randi_range(0 , lvlsize.x)
		fish.size.y = lvlsize.x
		$SubViewportContainer/SubViewport.add_child(fish)
		
	#start game on timer end
	await get_parent().get_child(0).timeout
	playing = true
	player.dir = Vector2(1 , 1)
	cam.limit_bottom = maxY

	

func _process(delta: float) -> void:
	
		

	line.points[1] = player.position - Vector2(2 , 14)
	$sheild.visible = sheilded #if shield is active, show the icon
	#pause fish and player on game pause
	if get_parent().paused == true:
		player.p = 0
		for i in fishes:
			i.p = 0
		$FrenzyTimer.paused = true
		if $FastDown.playing:
			$FastDown.volume_db = -30
			fastdownp = true
	else:
		if fastdownp:
			fastdownp = false
			$FastDown.volume_db = 0
		player.p = 1
		for i in fishes:
			i.p = 1
		$FrenzyTimer.paused = false
	#update camera and check player collision with walls
	cam.position.y = player.position.y
	if player.position.x >= lvlsize.x - (player.size.x / 2) - 2:
		player.dir.x = -1
	if player.position.x <= player.size.x / 2 + 2:
		player.dir.x = 1
	if player.position.y >= maxY - (player.size.y / 2):
		if player.dir.y == 2:
			player.dir.x = prev.x
		player.dir.y = -1
		if $FastDown.playing:
			$FastDown/Slow.play("Stop")
	#when th eplayer reaches the top, reset its stats and collect the fish for scoring
	if player.position.y <= 0 + (player.size.y / 2):
		cleared.emit()
		
		player.ext = Vector2(1 , 1)
		if big:
			big = false
			$Big/Reverse.play("Reverse")
			$Big.play()
		player.scale = Vector2(1 , 1)
		player.dir.y = 1
		var score = Global.score.instantiate()
		if $FrenzyTimer.time_left != 0:
			Global.scores[loaded] += player.held * 150
			score.t = "+" + str(player.held * 150)
			score.g = true
			$CashingIn.play()
		else:
			Global.scores[loaded] += player.held * 100
			score.t = "+" + str(player.held * 100)
			$CashingIn.play()
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
	#border control when hurt
	if $borderTime.time_left != 0:
		if $FrenzyTimer.time_left == 0:
			$border.self_modulate = Color(1 , 0 , 0 , $borderTime.time_left)
	

func _input(event: InputEvent) -> void:
	if playing: #only run if game is not paused
		if event.as_text() == Global.switch[loaded]: #if the button matches the keybind for the switch control
			if event.is_pressed() == true:
				if event.is_echo() == false:
					if ptimer.time_left == 0:
						player.dir *= Vector2(-1 , 1) #switch direction
						prev = player.dir #update prev
						ptimer.start() #start timer for detecting double clicks
					else:
						if player.dir.y > 0: #if double click speed downwards
							player.dir = Vector2(0 , 2)
							if !fastdown:
								$FastDown/Slow.play("RESET")
								$FastDown.play()
								fastdown = true
							
							
			
			else:
				if player.dir == Vector2(0 , 2):
					if $FastDown.playing:
						$FastDown/Slow.play("Stop")
						fastdown = false
						
					player.dir = prev #if key up and you were speeding down, reset dir to prev
		if event.as_text() == Global.use[loaded]: #if reel button is used, reel in if fish held > 0
			if event.is_pressed() == true:
				if event.is_echo() == false:
					if player.held > 0:
						if player.dir.y == 2:
							if $FastDown.playing:
								$FastDown/Slow.play("Stop")
								fastdown = false
							player.dir.x = prev.x
						player.dir.y = -1

#creates fishes. if remove is true, remove previous fish first
func create_fishes(remove):
	var skip = false
	#if remove, clear all fish
	if remove:
		for i in $SubViewportContainer/SubViewport.get_children():
			if i.has_method("fish"):
				$SubViewportContainer/SubViewport.remove_child(i)
				i.queue_free()
		fishes.clear()
	for i in (maxY - 200) / 100: #adds fish spaced out along entire level length - top portion
		if randi_range(0 , 3) > 0: #1/4 chance to not add fish
			fish_left += 1
			var newFish = Global.item.instantiate()
			newFish.type = "fish"
			if Global.settings["powerups"] == true:
				if randi_range(1 , 8) == 1: #1 in 16 chance to be a powerup instead of fish
					newFish.type = "power"
					fish_left -= 1
			#randomize new fish position
			newFish.position.x = randi_range(10 , lvlsize.x - 10)
			newFish.position.y = (100 * i) + 200
			
			#clear any fishes that are too close to eachother on the same y level to prevent weird collision bugs
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
	#add the bad guy fishes
	var bad = []
	for i in fishes:
		if i.type == "fish":
			bad.append(i)
	#randomly turn some fishes into evil fishes, but not too many
	for i in clamp(level , 0 , Global.settings["length"] * 2):
		var rand = randi_range(0 , bad.size() - 1)
		if bad.size() > 0:
			if bad[rand].type != "bad":
				bad[rand].type = "bad"
				bad[rand].upds()
				fish_left -= 1
	#add fishes into the game
	for i in fishes:
		$SubViewportContainer/SubViewport.add_child(i)
	#add in the (obs)tacles based on current level
	for i in level:
		var obs = Global.obs.instantiate()
		obs.position.x = Global.screen.x / Global.players * randi_range(0 , 1)
		if obs.position.x == 0:
			obs.position.x += 50 + randi_range(-lvlsize.x / 3, 25)
		else:
			obs.position.x -= 50 + randi_range(-25 , lvlsize.x / 3)
		obs.position.y = randi_range(100 , maxY)
		$SubViewportContainer/SubViewport.add_child(obs)

#handles powerup collection, type is the powerup name
func _on_player_power(type: Variant) -> void:
	match type:
		"sheild":
			#activate the shield
			sheilded = true
			$Shielded.play()
		"pslow":
			#gets all other active levels and slows the player speed
			for i in get_parent().get_child_count():
				if get_parent().get_child(i).has_method("_on_player_power"):
					if get_parent().get_child(i) != self:
						#remove shield if sheilded, otherwise run the effect
						if get_parent().get_child(i).sheilded == false:
							get_parent().get_child(i).player.ext = Vector2(0.5 , 1)
							$SlowDown.play()
						else:
							get_parent().get_child(i).sheilded = false
							$ShieldLost.play()
							
							
		"pfast":
			#gets all fish in other levels and makes them fast
			for i in get_parent().get_child_count():
				if get_parent().get_child(i).has_method("_on_player_power"):
					if get_parent().get_child(i) != self:
						if get_parent().get_child(i).sheilded == false:
							$SpeedUp.play()
							$SpeedUp/SpeedUp.play("SpeedUp")
							for k in get_parent().get_child(i).get_child(0).get_child(0).get_children():
								if k.has_method("fish"):
									if k.type != "power":
										k.speed = randi_range(175 , 300)
						else:
							get_parent().get_child(i).sheilded = false
							$ShieldLost.play()
		"bonus":
			$Bonus.play()
			#bonus points yay
			Global.scores[loaded] += 150
			var score = Global.score.instantiate()
			score.t = "+150"
			player.held += 1
			caught.emit(Global.BONUS)
			score.position = player.position
			player.get_parent().add_child(score)
		"size":
			$Big.play()
			big = true
			#makes the player bigger
			player.scale = Vector2(2 , 2)
		"frenzy":
			$Frenzy.play()
			#start the frenzy timer
			$FrenzyTimer.start()
			player.frenzy = true
			#set border
			$border.visible = true
			$border.self_modulate = Color.GOLD
		"trash1":
			#trash -points -hp
			if sheilded:
				sheilded = false
				$ShieldLost.play()
				
			else:
				$Plastic.play()
				Global.scores[loaded] -= 50
				_on_player_damaged()
				var score = Global.score.instantiate()
				score.t = "-50"
				score.g = false
				score.position = player.position
				player.get_parent().add_child(score)
		"trash2":
			#same as trash1
			if sheilded:
				sheilded = false
				$ShieldLost.play()
				
			else:
				$Plastic.play()
				Global.scores[loaded] -= 50
				_on_player_damaged()
				var score = Global.score.instantiate()
				score.t = "-50"
				score.g = false
				score.position = player.position
				player.get_parent().add_child(score)


func _on_player_damaged() -> void:
	
	$border.visible = true
	$borderTime.start()
	hp -= 1
	var score = Global.score.instantiate()
	score.t = "-1 HP"
	score.g = false
	score.position = player.position + Vector2(0 , 24)
	player.get_parent().add_child(score)
	if hp > 0:
		$Hurt.play()
	elif hp <= 0:
		$Dead.play()
		player.dir = Vector2(1 , 1)
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


func _on_frenzy_timer_timeout() -> void:
	#clear the border
	$border.visible = false


func _on_area_2d_body_entered(body):
	#playing the sounds
	if body.type == "fish":
		
		if !player.full:
			if $pop2.playing == false:
				$pop2.play()
		elif player.full:
			if !player.frenzy:
				$TooFull.play()
				
		

	


func _on_slow_animation_finished(anim_name):
	if anim_name == "Stop":
		$FastDown.stop()
