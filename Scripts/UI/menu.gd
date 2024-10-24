extends CenterContainer
signal inputs
var type: String
var buttons = {"main" : ["Play" , "Controls" , "Settings" , "Credits" , "Exit Game"] , 
"inGame": ["Start" , "Back"] , 
"controls": ["Player 1" , "Player 2" , "Player 3" , "Player 4" , "Back"] , 
"playing":["Resume" , "Controls" , "Quit"] , 
"editControls": ["Switch Directions" , "Use Item" , "Reset Controls" ,  "Back "] , 
"settings": ["Back"]}
var prev: String
var pc: int = 4
var block = false
var new: String


func _ready() -> void:
	size = Global.screen
	updateButtons()
	prev = type
	
func _process(delta: float) -> void:
	size = Global.screen
func _on_btn_clicked(btn):
	if !block:
		match btn:
			"Play":
				type = "inGame"
				addSelect(Global.players)
				updateButtons()
			"Back":
				type = prev
				updateButtons()
			"Back ":
				type = "controls"
				updateButtons()
			"Controls":
				type = "controls"
				updateButtons()
			"Start":
				get_parent().add_child(Global.game.instantiate())
				get_parent().remove_child(self)
				queue_free()
			"Resume":
				get_parent().paused = false
				get_parent().remove_child(self)
				queue_free()
			"Quit":
				get_tree().reload_current_scene()
			"Player 1":
				pc = 0
				type = "editControls"
				updateButtons()
			"Player 2":
				pc = 1
				type = "editControls"
				updateButtons()
			"Player 3":
				pc = 2
				type = "editControls"
				updateButtons()
			"Player 4":
				pc = 3
				type = "editControls"
				updateButtons()
			"Switch Directions":
				$ButtonHolder.get_child(1).get_child(0).text = "Awaiting Input"
				block = true
				await inputs
				Global.switch[pc] = new
				block = false
				updateButtons()
			"Use Item":
				$ButtonHolder.get_child(2).get_child(0).text = "Awaiting Input"
				block = true
				await inputs
				Global.use[pc] = new
				block = false
				updateButtons()
			"Reset Controls":
				Global.switch[pc] = Global.switchDef[pc]
				Global.use[pc] = Global.useDef[pc]
				updateButtons()
			"Exit Game":
				get_tree().quit()
			"Settings":
				type = "settings"
				updateButtons()
			_:
				print("could not find button: " , btn)
			
func _on_close(node):
	Global.players -= 1
	for i in $ButtonHolder/C/HButtonHolder.get_child_count():
		if $ButtonHolder/C/HButtonHolder.get_child(i) == node:
			Global.playerNames.remove_at(i)
			Global.col.remove_at(i)
	for i in $ButtonHolder/C/HButtonHolder.get_children():
		$ButtonHolder/C/HButtonHolder.remove_child(i)
		i.queue_free()
	addSelect(Global.players)
		
func _on_add():
	Global.players += 1
	Global.col.append(Global.players - 1)
	Global.playerNames.append("Player " + str($ButtonHolder/C/HButtonHolder.get_child_count()))
	for i in $ButtonHolder/C/HButtonHolder.get_children():
		$ButtonHolder/C/HButtonHolder.remove_child(i)
		i.queue_free()
	addSelect(Global.players)
	
func updateButtons():
	for i in $ButtonHolder.get_children():
		if i is not CenterContainer:
			$ButtonHolder.remove_child(i)
			i.queue_free()
		elif i.name == "Settings":
			$ButtonHolder.remove_child(i)
			i.queue_free()
	if type != "inGame":
		for i in $ButtonHolder/C/HButtonHolder.get_children():
			$ButtonHolder/C/HButtonHolder.remove_child(i)
			i.queue_free()
	if type == "settings":
		var menu = Global.setting.instantiate()
		$ButtonHolder.add_child(menu)
	for i in buttons[type].size():
		var newbtn = Global.menuBtnScn.instantiate()
		newbtn.btnName = buttons[type][i]
		if pc < 4:
			newbtn.alt = pc
		$ButtonHolder.add_child(newbtn)
		newbtn.connect("clicked" , Callable(self , "_on_btn_clicked"))
		
func addSelect(num):
	for i in clamp(num + 1 , 1 , 4):
		var newbtn = Global.plrBtnScn.instantiate()
		if i != num:
			newbtn.playerName = Global.playerNames[i]
		newbtn.connect("close" ,  Callable(self , "_on_close"))
		newbtn.connect("add" , Callable(self , "_on_add"))
		if i <= Global.players - 1:
			newbtn.plr = i
		$ButtonHolder/C/HButtonHolder.add_child(newbtn)

func _input(event: InputEvent) -> void:
	if event.as_text().length() < 14:
		new = event.as_text()
		inputs.emit()
