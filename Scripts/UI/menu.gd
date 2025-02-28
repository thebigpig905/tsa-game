extends CenterContainer
signal inputs
#what menu to load
var type: String
#buttons that go with each menu type
var buttons = {"main" : ["Play" , "Settings" , "Credits" , "Exit Game"] , 
"inGame": ["Start" , "Settings" , "Back"] , 
"controls": ["Player 1" , "Player 2" , "Player 3" , "Player 4" , "Back"] , 
"playing":["Resume" , "Controls" , "Quit"] , 
"editControls": ["Switch Directions" , "Reel In Hook" , "Reset Controls" ,  "Back"] , 
"settings": ["Reset" , "Controls" , "Back"] , 
"end": ["Main Menu"]}
#what page was the menu first loaded on
var prev = []
#idfk
var pc: int = 4
#block button inputs
var block = false
#i forgor
var new: String


func _ready() -> void:
	size = Global.screen #resize
	updateButtons() #read it
	if type == "main":
		for i in randi_range(20 , 30):
			var fish = Global.backgroundfish.instantiate()
			fish.position.y = randi_range(0 , Global.screen.y)
			fish.position.x = randi_range(0 , Global.screen.x)
			fish.size.y = Global.screen.x
			get_parent().add_child(fish)
			get_parent().fish.append(fish)
	
func _process(delta: float) -> void:
	size = Global.screen #resize constantly
func _on_btn_clicked(btn): #btn in type of button that was pressed
	if !block: 
		match btn: #runs logic for buttons on pressed
			"Play":
				prev.append(type)
				type = "inGame" #sets the menu type so the buttons change when reloaded
				addSelect(Global.players) #special line
				updateButtons() #reloads menu
			"Back":
				type = prev.pop_back()
				if type == "inGame":
					addSelect(Global.players)
				updateButtons()
			"Controls":
				prev.append(type)
				type = "controls"
				updateButtons()
			"Start":
				for i in get_parent().fish:
					get_parent().remove_child(i)
					i.queue_free()
				get_parent().fish.clear()
				get_parent().mmus.stop()
				get_parent().add_child(Global.game.instantiate()) #starts the main game
				get_parent().remove_child(self) #removes self
				queue_free()
			"Resume":
				get_parent().paused = false
				get_parent().remove_child(self)
				queue_free()
			"Quit":
				get_tree().reload_current_scene() #restarts the game
			"Player 1":
				pc = 0
				prev.append(type)
				type = "editControls"
				updateButtons()
			"Player 2":
				pc = 1
				prev.append(type)
				type = "editControls"
				updateButtons()
			"Player 3":
				pc = 2
				prev.append(type)
				type = "editControls"
				updateButtons()
			"Player 4":
				pc = 3
				prev.append(type)
				type = "editControls"
				updateButtons()
			"Switch Directions":
				$ButtonHolder.get_child(1).get_child(0).text = "Awaiting Input"
				block = true
				await inputs
				Global.switch[pc] = new
				block = false
				updateButtons()
			"Reel In Hook":
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
				get_tree().quit() #exits the game
			"Settings":
				prev.append(type)
				type = "settings"
				updateButtons()
			"Reset":
				for i in Global.settings:
					Global.settings[i] = Global.settingsDef[i]
				updateButtons()
			"Main Menu":
				get_tree().reload_current_scene()
			"Credits":
				get_parent().add_child(Global.cred.instantiate())
				get_parent().remove_child(self)
				queue_free()
			_:
				print("could not find button: " , btn) #if button pressed does not appear in the above list, add it
		print(prev)
			
func _on_close(node): #removes player from selection screen
	if Global.players > 1:
		Global.players -= 1  #removes player grom global player var
		for i in $ButtonHolder/C/HButtonHolder.get_child_count(): #runs through other player selections to match it
			if $ButtonHolder/C/HButtonHolder.get_child(i) == node:
				Global.playerNames.remove_at(i) #if it is matched remove the playername in that position from global var
				Global.playerps.remove_at(i)
				Global.col.remove_at(i) #same with selected color
		for i in $ButtonHolder/C/HButtonHolder.get_children(): #removes all player select buttons to be reloaded
			$ButtonHolder/C/HButtonHolder.remove_child(i)
			i.queue_free()
		addSelect(Global.players) #reloads player selection
		
func _on_add(): #add player when told to
	Global.players += 1 #add player to global var
	Global.col.append(Global.players - 1) #adds a default color for the player select
	Global.playerNames.append("Player " + str($ButtonHolder/C/HButtonHolder.get_child_count())) #generates name
	Global.playerps.append(0)
	for i in $ButtonHolder/C/HButtonHolder.get_children(): #removes all player select buttons to be reloaded
		$ButtonHolder/C/HButtonHolder.remove_child(i)
		i.queue_free()
	addSelect(Global.players) #reloads player selection
	
func updateButtons():
	for i in $ButtonHolder.get_children():
		if i is not CenterContainer: #centerContainer is there for player selection screen
			$ButtonHolder.remove_child(i) #removes all old buttons
			i.queue_free()
		elif i.name == "Settings": #remove if centerContainer is the settings scene
			$ButtonHolder.remove_child(i)
			i.queue_free()
	if type != "inGame":
		for i in $ButtonHolder/C/HButtonHolder.get_children():
			$ButtonHolder/C/HButtonHolder.remove_child(i)
			i.queue_free()
	if type == "settings":
		var menu = Global.setting.instantiate() #if you are loading the settings page, add the settings scene
		
		$ButtonHolder.add_child(menu)
	if type == "main":
		print(size.x)
		var title = Global.title.instantiate()
		title.add_theme_constant_override("margin_left" , 100)
		$ButtonHolder.add_child(title)
	for i in buttons[type].size(): #runs through the array of button names in the dictionary with the keythat is the type of menu loaded
		var newbtn = Global.menuBtnScn.instantiate()
		newbtn.btnName = buttons[type][i]
		if pc < 4:
			newbtn.alt = pc
		$ButtonHolder.add_child(newbtn)
		newbtn.connect("clicked" , Callable(self , "_on_btn_clicked")) #connects the clicked signal to the button
		
func addSelect(num):
	for i in clamp(num + 1 , 1 , 4): #clamps at 4 because 4 is max players
		var newbtn = Global.plrBtnScn.instantiate()
		if i != num:
			newbtn.playerName = Global.playerNames[i]
		newbtn.connect("close" ,  Callable(self , "_on_close"))
		newbtn.connect("add" , Callable(self , "_on_add"))
		if i <= Global.players - 1:
			newbtn.plr = i
		$ButtonHolder/C/HButtonHolder.add_child(newbtn)

func _input(event: InputEvent) -> void:
	if event.as_text().length() < 14: #this is for button rebinding
		new = event.as_text()
		inputs.emit()
