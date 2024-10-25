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

var len = 1000
var maxY:int


func _ready() -> void:
	background.color = Global.colors[Global.col[loaded]]
	background.size.x = size.x
	background.size.y = len + (len * ((Global.settings["length"] - 1) / 2.0)) #base length + half of length level
	maxY = background.size.y
	lvlsize = size
	player.position.x = size.x / 2
	$SubViewportContainer.size = lvlsize
	$SubViewportContainer/SubViewport.size = lvlsize
	cam.position.x = $SubViewportContainer.size.x / 2
	left.get_child(0).scale.y = maxY / 5
	left.position.x = -5
	left.position.y = (maxY / 2) - 150
	right.get_child(0).scale.y = maxY / 5
	right.position.x = lvlsize.x + 5
	right.position.y = (maxY / 2) - 150
	top.get_child(0).scale.x = lvlsize.x / 10
	top.position.x = lvlsize.x / 2
	top.position.y = -5
	bottom.get_child(0).scale.x = lvlsize.x / 10
	bottom.position.x = lvlsize.x / 2
	bottom.position.y = background.size.y + 5
	for i in (maxY - 200) / 100:
		if randi_range(0 , 2) > 0:
			var newFish = Global.item.instantiate()
			newFish.type = "fish"
			if Global.settings["powerups"] == true:
				if randi_range(1 , 16) == 3:
					newFish.type = "power"
			newFish.position.x = randi_range(10 , lvlsize.x - 10)
			newFish.position.y = (100 * i) + 200
			$SubViewportContainer/SubViewport.add_child(newFish)
	await get_parent().get_child(0).timeout
	playing = true
	player.dir = Vector2(1 , 1)
	cam.limit_bottom = maxY
	

func _process(delta: float) -> void:
	cam.position.y = player.position.y
	if player.position.x >= lvlsize.x - (player.size.x / 2):
		player.dir.x = -1
	if player.position.x <= player.size.x / 2:
		player.dir.x = 1
	if player.position.y >= maxY - (player.size.y / 2):
		player.dir.y = -1
		player.dir.x = prev.x
	if player.position.y <= 0 + (player.size.y / 2):
		player.dir.y = 1
		Global.scores[loaded] += player.held
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
