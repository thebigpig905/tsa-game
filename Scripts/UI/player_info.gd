extends CenterContainer
var plr:int

#important nodes
@onready var score: Label = $VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer/Score
@onready var plrname: Label = $VBoxContainer/ColorRect/Name
@onready var plrbox: ColorRect = $VBoxContainer/ColorRect
@onready var v: VBoxContainer = $VBoxContainer
@onready var h: HBoxContainer = $VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer
@onready var hp: Label = $VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/hp
@onready var hp_bar: TextureProgressBar = $VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/TextureProgressBar
@onready var fishdisp: HBoxContainer = $VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer2

var fishes = []
var blank = preload("res://Assets/Textures/blkfsh.png")
var sizex:int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#resize elements and position them correctly
	sizex = size.x
	v.custom_minimum_size = size
	plrbox.custom_minimum_size = size / Vector2(1 , 3)
	plrname.custom_minimum_size = size / Vector2(1 , 3)
	plrbox.color = Global.colors[Global.col[plr]]
	score.custom_minimum_size.y = size.y / 4
	h.custom_minimum_size.y = size.y / 4
	hp.custom_minimum_size.y = size.y / 4
	fishdisp.custom_minimum_size.y = size.y / 4
	plrname.text = Global.playerNames[plr]
	for i in Global.settings["weight"]:
		fishes.append(blank)
	get_parent().get_parent().get_parent().levels[plr].connect("caught" , Callable(self , "_on_catch"))
	get_parent().get_parent().get_parent().levels[plr].connect("cleared" , Callable(self , "_on_clear"))
	update()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#update text constantly
	score.text = "Score: " + str(Global.scores[plr])
	hp_bar.value = (get_parent().get_parent().get_parent().levels[plr].hp / float(Global.settings["lives"])) * 100

func _on_catch(textur):
	if fishes[-1] != blank:
		fishes.append(textur)
	for i in fishes.size():
		if fishes[i] == blank:
			fishes[i] = textur
			update()
			break
		update()
func update():
	for i in fishdisp.get_children():
		fishdisp.remove_child(i)
		i.queue_free()
	for i in fishes:
		var fish = TextureRect.new()
		fish.texture = i
		fishdisp.add_child(fish)
	#fix separation so size stays good
	fishdisp.add_theme_constant_override("separation" , clamp((((Global.screen.x / Global.players) - 20) - (32 * clamp(get_parent().get_parent().get_parent().levels[plr].player.held , Global.settings["weight"] , INF))) / (clamp(get_parent().get_parent().get_parent().levels[plr].player.held , Global.settings["weight"] , INF)-1) , -INF , 4))
	#
func _on_clear():
	fishes.clear()
	for i in Global.settings["weight"]:
		fishes.append(blank)
	update()
