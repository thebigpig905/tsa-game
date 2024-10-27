extends CenterContainer
var plr:int
var loaded:int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HBoxContainer/background/PlayerName.text = Global.playerNames[plr]
	$HBoxContainer/background.color = Global.colors[Global.col[plr]]
	$HBoxContainer/ScoreBG/HBoxContainer/MarginContainer/Score.text = "Score: " + str(Global.scores[plr])
	$HBoxContainer/ScoreBG/HBoxContainer/Place.text ="#" + str(loaded + 1)
	match loaded:
		0:
			$HBoxContainer/ScoreBG/HBoxContainer/Place.add_theme_color_override("font_color" , Color.GOLD)
		1:
			$HBoxContainer/ScoreBG/HBoxContainer/Place.add_theme_color_override("font_color" , Color.SILVER)
		2:
			$HBoxContainer/ScoreBG/HBoxContainer/Place.add_theme_color_override("font_color" , Color.SADDLE_BROWN)

	
