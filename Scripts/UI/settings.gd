extends CenterContainer
var inGame:bool = false


func _ready() -> void:
	$HBoxContainer/VBoxContainer/Powers.button_pressed = Global.settings["powerups"]
	$HBoxContainer/VBoxContainer/Teams.button_pressed = Global.settings["teams"]
	match Global.settings["length"]:
		1:
			$"HBoxContainer/VBoxContainer/Level Length".selected = 0
		2:
			$"HBoxContainer/VBoxContainer/Level Length".selected = 1
		4:
			$"HBoxContainer/VBoxContainer/Level Length".selected = 2
		6:
			$"HBoxContainer/VBoxContainer/Level Length".selected = 3
	$HBoxContainer/VBoxContainer/Rounds.text = str(Global.settings["rounds"])
	$"HBoxContainer/VBoxContainer/Max Lives".text = str(Global.settings["lives"])
	$HBoxContainer/VBoxContainer/Time.text = str(Global.settings["timer"])
	$HBoxContainer/VBoxContainer/Weight.text = str(Global.settings["weight"])
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if inGame:
		size = Global.screen
		position = Global.screen / 2


func _on_powers_toggled(toggled_on: bool) -> void:
	Global.settings["powerups"] = toggled_on


func _on_teams_toggled(toggled_on: bool) -> void:
	Global.settings["teams"] = toggled_on


func _on_level_length_item_selected(index: int) -> void:
	match index:
		0:
			Global.settings["length"] = 1
		1:
			Global.settings["length"] = 2
		2:
			Global.settings["length"] = 4
		3:
			Global.settings["length"] = 6


func _on_rounds_text_changed(new_text: String) -> void:
	Global.settings["rounds"] = clamp(int(new_text) , 1 , INF)


func _on_max_lives_text_changed(new_text: String) -> void:
	Global.settings["lives"] = clamp(int(new_text) , 1 , INF)


func _on_time_text_changed(new_text: String) -> void:
	Global.settings["timer"] = clamp(int(new_text) , 1 , INF)


func _on_weight_text_submitted(new_text: String) -> void:
	Global.settings["weight"] = clamp(int(new_text) , 1 , INF)
