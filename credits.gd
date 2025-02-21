extends CenterContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	size = Global.screen
	var btns = Global.menuBtnScn.instantiate()
	btns.btnName = "Back"
	btns.connect("clicked" , Callable(self , "_on_btn_clicked"))
	$VBoxContainer.add_child(btns)


func _on_btn_clicked(btn):
	var mm = Global.menu.instantiate()
	mm.type = "main"
	get_parent().add_child(mm)
	get_parent().remove_child(self)
	queue_free()
