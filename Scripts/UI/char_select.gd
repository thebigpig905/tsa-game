extends ColorRect
signal close(node)
signal add()
var playerName: String = ""
var team: int
var isin: bool = false
var editing: bool = false
var colornum:int
var plr:int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	updateVis()
	colornum = Global.col[plr]
	$MarginContainer/CenterContainer/VBoxContainer/B/HBoxContainer/PlayerCol.color = Global.colors[Global.col[plr]]

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("clickL"):
		if isin:
			if playerName == "":
				add.emit()

func updateVis():
	if playerName != "":
		$MarginContainer/CenterContainer/VBoxContainer/MarginContainer/Name.text = playerName
		$MarginContainer/CenterContainer/VBoxContainer/P/PlayerIcon.visible = true
		$MarginContainer/CenterContainer/VBoxContainer/B/HBoxContainer.visible = true
		$MarginContainer/CenterContainer/VBoxContainer/Spacer.visible = true
		$Remove.visible = true
		$Rename.visible = true
	else:
		$MarginContainer/CenterContainer/VBoxContainer/P/PlayerIcon.visible = false
		$MarginContainer/CenterContainer/VBoxContainer/B/HBoxContainer.visible = false
		$MarginContainer/CenterContainer/VBoxContainer/Spacer.visible = false
		$Remove.visible = false
		$Rename.visible = false



func _on_mouse_entered() -> void:
	isin = true


func _on_mouse_exited() -> void:
	isin = false




func _on_remove_clicked() -> void:
	close.emit(self)


func _on_rename_clicked() -> void:
	$MarginContainer/CenterContainer/LineEdit.visible = true
	


func _on_line_edit_text_changed(new_text: String) -> void:
	$MarginContainer/CenterContainer/VBoxContainer/MarginContainer/Name.text = $MarginContainer/CenterContainer/LineEdit.text


func _on_line_edit_text_submitted(new_text: String) -> void:
	if $MarginContainer/CenterContainer/LineEdit.text != "":
		for i in get_parent().get_child_count():
			if get_parent().get_child(i) == self:
				Global.playerNames[i] = $MarginContainer/CenterContainer/LineEdit.text
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
