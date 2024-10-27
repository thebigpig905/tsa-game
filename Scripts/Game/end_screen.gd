extends CenterContainer
var sort = []
var plrs = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	size = Global.screen
	for i in Global.players:
		if i == 0:
			sort.append(Global.scores[i])
			plrs.append(0)
		else:
			for k in sort.size():
				if Global.scores[i] > sort[k]:
					sort.insert(k , Global.scores[i])
					plrs.insert(k , i)
					break
				if k == sort.size() - 1:
					sort.append(Global.scores[i])
					plrs.append(i)
	print(plrs)
	for i in Global.players:
		var plr = Global.endPlr.instantiate()
		plr.loaded = i
		plr.plr = plrs[i]
		$VBoxContainer.add_child(plr)
	var btns = Global.menuBtnScn.instantiate()
	btns.btnName = "Main Menu"
	btns.connect("clicked" , Callable(self , "_on_btn_clicked"))
	$VBoxContainer.add_child(btns)


func _on_btn_clicked(btn):
	get_tree().reload_current_scene()
