extends Node2D

func _ready() -> void:
	var mm = Global.menu.instantiate() #instantiates a menu on game start
	mm.type = "main"
	add_child(mm)
func startgame(score , round):
	for i in get_children():
		remove_child(i)
		i.queue_free()
	var g = Global.game.instantiate()
	g.round = round
	add_child(g)
	Global.scores = score
	
