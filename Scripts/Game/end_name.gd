extends CenterContainer
var plr:int
var loaded:int
var type = "scores"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HBoxContainer/background/PlayerName.text = Global.playerNames[plr]
	$HBoxContainer/background.self_modulate = Global.colors[Global.col[plr]]
	$HBoxContainer/MarginContainer/PlayerIcon.texture = Global.pfps[Global.playerps[plr]]
	if type == "scores":
		$HBoxContainer/ScoreBG/HBoxContainer/MarginContainer/Score.text = "Score: " + str(Global.scores[plr])
	if type == "total":
		$HBoxContainer/ScoreBG/HBoxContainer/MarginContainer/Score.text = "Total Score: " + str(Global.total[plr])
	$HBoxContainer/ScoreBG/HBoxContainer/Place.text ="#" + str(loaded + 1)
	#set text color based on place
	match loaded:
		0:
			$HBoxContainer/ScoreBG/HBoxContainer/Place.add_theme_color_override("font_color" , Color.GOLD)
			$HBoxContainer/MarginContainer/crown.visible = true
		1:
			$HBoxContainer/ScoreBG/HBoxContainer/Place.add_theme_color_override("font_color" , Color.SILVER)
		2:
			$HBoxContainer/ScoreBG/HBoxContainer/Place.add_theme_color_override("font_color" , Color.SADDLE_BROWN)

	
