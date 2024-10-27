extends Node2D

func _ready() -> void:
	var mm = Global.menu.instantiate() #instantiates a menu on game start
	mm.type = "main"
	add_child(mm)
