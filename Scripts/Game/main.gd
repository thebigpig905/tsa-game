extends Node2D
signal tstsig()
#musics
@onready var mmus: AudioStreamPlayer = $AudioStreamPlayer
var fish = []

func _ready() -> void:
	var mm = Global.menu.instantiate() #instantiates a menu on game start
	mm.type = "main"
	add_child(mm)
	
#start new game without reloading to save scores
func startgame(round):
	print(Global.total)
	for i in get_children():
		if i.name != "AudioStreamPlayer" and i.name != "Click":
			remove_child(i)
			i.queue_free()
	var g = Global.game.instantiate()
	g.round = round
	add_child(g)
func _process(delta):
	if Input.is_action_just_pressed("clickL"):
		$Click.play()
		#print("Click")
		
