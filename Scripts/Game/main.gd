extends Node2D

#musics
@onready var mmus: AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
	var mm = Global.menu.instantiate() #instantiates a menu on game start
	mm.type = "main"
	add_child(mm)
	
#start new game without reloading to save scores
func startgame(round):
	print(Global.total)
	for i in get_children():
		remove_child(i)
		i.queue_free()
	var g = Global.game.instantiate()
	g.round = round
	add_child(g)
	
