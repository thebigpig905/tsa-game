extends CenterContainer
var sort = []
var plrs = []
var prev

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	size = Global.screen
	update(Global.scores)
	if Global.settings["rounds"] != 1:
		var next = Global.menuBtnScn.instantiate()
		next.btnName = "Continue"
		next.connect("clicked" , Callable(self , "_cont"))
		$VBoxContainer.add_child(next)
	var btns = Global.menuBtnScn.instantiate()
	btns.btnName = "Main Menu"
	btns.connect("clicked" , Callable(self , "_on_btn_clicked"))
	$VBoxContainer.add_child(btns)


func _on_btn_clicked(btn):
	get_tree().reload_current_scene()
	
func _next(btn):
	get_parent().round += 1
	get_parent().get_parent().startgame(get_parent().round)

func _cont(btn):
	if Global.total.size() == 0:
		Global.total = Global.scores
	else:
		for i in Global.scores.size():
			Global.total[i] += Global.scores[i]
	update(Global.total)
	if Global.settings["rounds"] - get_parent().round > 0:
		var next = Global.menuBtnScn.instantiate()
		next.btnName = "Next Round"
		next.connect("clicked" , Callable(self , "_next"))
		$VBoxContainer.add_child(next)
	var btns = Global.menuBtnScn.instantiate()
	btns.btnName = "Main Menu"
	btns.connect("clicked" , Callable(self , "_on_btn_clicked"))
	$VBoxContainer.add_child(btns)

func update(li):
	plrs.clear()
	sort.clear()
	for i in $VBoxContainer.get_children():
		$VBoxContainer.remove_child(i)
		i.queue_free()
	for i in Global.players: #runs once for each player
		if i == 0: #if its the first time through just append it
			sort.append(li[i])
			plrs.append(0)
		else: #else
			for k in sort.size(): #runs through the already sorted items
				if li[i] > sort[k]: #if the new item is less than old items insert it
					sort.insert(k , li[i])
					plrs.insert(k , i)
					break
				if k == sort.size() - 1: #if it was not sorted, append it
					sort.append(li[i])
					plrs.append(i)
	if Global.settings["rounds"] > 1:
		var l = Global.roundnum.instantiate()
		l.text = "Round " + str(get_parent().round)
		$VBoxContainer.add_child(l)
	for i in Global.players: #runs for each player
		var plr = Global.endPlr.instantiate() 
		if i != 0: 
			if sort[i] == sort[i - 1]:
				plr.loaded = prev
			else:
				plr.loaded = i 
				prev = i
		else: #if first time through
			plr.loaded = i
			prev = i
		plr.plr = plrs[i]
		if li == Global.total:
			plr.type = "total"
		$VBoxContainer.add_child(plr)
