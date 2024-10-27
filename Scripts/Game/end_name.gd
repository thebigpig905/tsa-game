extends CenterContainer
var plr:int
var loaded:int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	$HBoxContainer/background/PlayerName.text = Global.playerNames[plr]
	$HBoxContainer/background.color = Global.colors[Global.col[plr]]
	$HBoxContainer/ScoreBG/HBoxContainer/Score.text = "Score: " + str(Global.scores[plr])
	$HBoxContainer/ScoreBG/HBoxContainer/Place.text ="#" + str(loaded + 1)
	
