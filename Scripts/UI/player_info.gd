extends CenterContainer
var plr:int

#important nodes
@onready var fish: Label = $VBoxContainer/MarginContainer/VBoxContainer/fish
@onready var score: Label = $VBoxContainer/MarginContainer/VBoxContainer/Score
@onready var plrname: Label = $VBoxContainer/ColorRect/Name
@onready var plrbox: ColorRect = $VBoxContainer/ColorRect
@onready var v: VBoxContainer = $VBoxContainer
@onready var h: HBoxContainer = $VBoxContainer/MarginContainer/VBoxContainer/HBoxContainer
@onready var hp: Label = $VBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/hp
@onready var hp_bar: TextureProgressBar = $VBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/TextureProgressBar


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#resize elements and position them correctly
	v.custom_minimum_size = size
	plrbox.custom_minimum_size = size / Vector2(1 , 3)
	plrname.custom_minimum_size = size / Vector2(1 , 3)
	plrbox.color = Global.colors[Global.col[plr]]
	score.custom_minimum_size.y = size.y / 4
	fish.custom_minimum_size.y = size.y / 4
	h.custom_minimum_size.y = size.y / 4
	hp.custom_minimum_size.y = size.y / 4
	plrname.text = Global.playerNames[plr]
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#update text constantly
	score.text = "Score: " + str(Global.scores[plr])
	fish.text = "Fish held: " + str(get_parent().get_parent().get_parent().levels[plr].player.held) + "/" + str(Global.settings["weight"])
	hp_bar.value = (get_parent().get_parent().get_parent().levels[plr].hp / float(Global.settings["lives"])) * 100
