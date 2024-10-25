extends CenterContainer
var plr:int
@onready var score: Label = $VBoxContainer/HBoxContainer/VBoxContainer/Score
@onready var fish: Label = $VBoxContainer/HBoxContainer/VBoxContainer/fish
@onready var plrname: Label = $VBoxContainer/ColorRect/Name
@onready var color_rect: ColorRect = $VBoxContainer/HBoxContainer/CenterContainer/HBoxContainer/ColorRect
@onready var color_rect_2: ColorRect = $VBoxContainer/HBoxContainer/CenterContainer/HBoxContainer/ColorRect2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$VBoxContainer/ColorRect.custom_minimum_size = size / Vector2(1 , 3)
	plrname.custom_minimum_size = size / Vector2(1 , 3)
	$VBoxContainer/ColorRect.color = Global.colors[Global.col[plr]]
	$VBoxContainer/HBoxContainer.custom_minimum_size.x = size.x
	$VBoxContainer/HBoxContainer.custom_minimum_size.y = (size.y / 3) * 2
	plrname.text = Global.playerNames[plr]
	score.custom_minimum_size.y = size.y / 3
	score.custom_minimum_size.x = size.x / 2
	fish.custom_minimum_size.y = size.y / 3
	fish.custom_minimum_size.x = size.x / 2
	$VBoxContainer/HBoxContainer/CenterContainer.custom_minimum_size.y = (size.y / 3) * 2
	$VBoxContainer/HBoxContainer/CenterContainer.custom_minimum_size.x = size.x / 2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	score.text = "Score: " + str(Global.scores[plr])
	fish.text = "Fish held: " + str(get_parent().get_parent().get_parent().levels[plr].player.held) + "/" + str(Global.settings["weight"])
