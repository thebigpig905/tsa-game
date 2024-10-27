extends CenterContainer
var sort = []
var plrs = []
var prev

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
	if Global.settings["rounds"] > 1:
		var l = Global.roundnum.instantiate()
		l.text = "Round " + str(get_parent().round)
		$VBoxContainer.add_child(l)
	for i in Global.players:
		var plr = Global.endPlr.instantiate()
		if i != 0:
			if sort[i] == sort[i - 1]:
				plr.loaded = prev
			else:
				plr.loaded = i
				prev = i
		else:
			plr.loaded = i
			prev = i
		plr.plr = plrs[i]
		$VBoxContainer.add_child(plr)
	if Global.settings["rounds"] - get_parent().round > 0:
		var next = Global.menuBtnScn.instantiate()
		next.btnName = "Next Round"
		next.connect("clicked" , Callable(self , "_next"))
		$VBoxContainer.add_child(next)
	var btns = Global.menuBtnScn.instantiate()
	btns.btnName = "Main Menu"
	btns.connect("clicked" , Callable(self , "_on_btn_clicked"))
	$VBoxContainer.add_child(btns)


func _on_btn_clicked(btn):
	get_tree().reload_current_scene()
	
func _next(btn):
	get_parent().round += 1
	get_parent().get_parent().startgame(Global.scores , get_parent().round)
