extends TextureRect
signal close(node) #for removing player (node) is the player that is to be removed
signal add() #for adding player
var playerName: String = "" #name of player
var isin: bool = false #for adding a player
var editing: bool = false #for renaming i think
var colornum:int #number that controlswhat color it is
var plr:int #what player the card goes with
var pfpnum = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	updateVis() #updates layout/visibility
	colornum = Global.col[plr] #sets the color
	$MarginContainer/CenterContainer/VBoxContainer/B/HBoxContainer/PlayerCol.color = Global.colors[Global.col[plr]]

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("clickL"): #if click
		if isin: #and isin
			if playerName == "": #and the name is empty
				add.emit() #add player
	$Rename.position.x = $MarginContainer/CenterContainer/VBoxContainer/MarginContainer/Name.position.x

func updateVis():
	if playerName != "": #if the name is not empty
		$MarginContainer/CenterContainer/VBoxContainer/MarginContainer/Name.text = playerName #set the name text to the name
		$MarginContainer/CenterContainer/VBoxContainer/P/PlayerIcon.visible = true#player icon should be visible
		$MarginContainer/CenterContainer/VBoxContainer/B/HBoxContainer.visible = true #color picker
		$MarginContainer/CenterContainer/VBoxContainer/Spacer.visible = true #the spacer adds a space
		$Remove.visible = true #the remove player button
		$Rename.visible = true #the rename player button
		$PFP.visible = true
		$MarginContainer/CenterContainer/VBoxContainer/P/PlayerIcon.texture = Global.pfps[Global.playerps[plr]]
	else:
		$MarginContainer/CenterContainer/VBoxContainer/P/PlayerIcon.visible = false #everyhting should be not visible
		$MarginContainer/CenterContainer/VBoxContainer/B/HBoxContainer.visible = false
		$MarginContainer/CenterContainer/VBoxContainer/Spacer.visible = false
		$Remove.visible = false
		$Rename.visible = false
		$PFP.visible = false

func _on_mouse_entered() -> void:
	isin = true

func _on_mouse_exited() -> void:
	isin = false

func _on_remove_clicked() -> void:
	close.emit(self)

func _on_rename_clicked() -> void:
	$MarginContainer/CenterContainer/LineEdit.visible = true #on rename clicked, make the rename box visible

func _on_line_edit_text_changed(new_text: String) -> void:
	if $MarginContainer/CenterContainer/LineEdit.text != "":
		for i in get_parent().get_child_count():
			if get_parent().get_child(i) == self:
				Global.playerNames[i] = $MarginContainer/CenterContainer/LineEdit.text
				$MarginContainer/CenterContainer/VBoxContainer/MarginContainer/Name.text = Global.playerNames[i]


func _on_line_edit_text_submitted(new_text: String) -> void:
	$MarginContainer/CenterContainer/LineEdit.visible = false


func _on_left_arr_clicked() -> void:
	colornum -= 1
	if colornum < 0:
		colornum = 7
	Global.col[plr] = colornum
	$MarginContainer/CenterContainer/VBoxContainer/B/HBoxContainer/PlayerCol.color = Global.colors[Global.col[plr]]
	print(Global.col)


func _on_right_arr_clicked() -> void:
	colornum += 1
	if colornum > 7:
		colornum = 0
	Global.col[plr] = colornum
	$MarginContainer/CenterContainer/VBoxContainer/B/HBoxContainer/PlayerCol.color = Global.colors[Global.col[plr]]
	print(Global.col)


func _on_pfp_clicked() -> void:
	pfpnum += 1
	if pfpnum >= Global.pfps.size():
		pfpnum = 0
	$MarginContainer/CenterContainer/VBoxContainer/P/PlayerIcon.texture = Global.pfps[pfpnum]
	Global.playerps[plr] = pfpnum
