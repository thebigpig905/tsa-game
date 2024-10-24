extends Node2D

func _ready() -> void:
	var mm = Global.menu.instantiate()
	mm.type = "main"
	add_child(mm)
