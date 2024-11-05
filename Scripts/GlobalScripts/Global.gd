extends Node

var players: int = 2
var menuBtnScn = preload("res://Scenes/menuButton.tscn")
var plrBtnScn = preload("res://Scenes/CharSelect.tscn")
var menu = preload("res://Scenes/menu.tscn")
var lineEdit = preload("res://Scenes/line_edit.tscn")
var game = preload("res://Scenes/game.tscn")
var level = preload("res://Scenes/level.tscn")
var player = preload("res://Scenes/player.tscn")
var item = preload("res://Scenes/powerup.tscn")
var setting = preload("res://Scenes/settings.tscn")
var info = preload("res://Scenes/player_info.tscn")
var stats = preload("res://Scenes/stats.tscn")
var endScreen = preload("res://Scenes/end_screen.tscn")
var endPlr = preload("res://Scenes/end_name.tscn")
var roundnum = preload("res://Scenes/round.tscn")
var obs = preload("res://Scenes/obstacle.tscn")
var score = preload("res://Scenes/score.tscn")

var playerNames = ["Player 1" , "Player 2"]
var col = [0 , 1]
var scores = []
var total = []
var powers = []

var switch = ["Q" , "O" , "Left" , "Kp 5"]
var use = ["W" , "P" , "Right" , "Kp 6"]
var switchDef = ["Q" , "O" , "Left" , "Kp 5"]
var useDef = ["W" , "P" , "Right" , "Kp 6"]

var settings = {"rounds": 1 , "powerups": true , "lives": 5 , "teams": false , "timer": 180 , "weight": 5 , "length": 2}
var settingsDef = {"rounds": 1 , "powerups": true , "lives": 5 , "teams": false , "timer": 180 , "weight": 5 , "length": 2}

var screen:Vector2 = DisplayServer.window_get_size()

const BLUE_FISH = preload("res://Assets/Placeholders/blueFish.png")
const GREEN_FISH = preload("res://Assets/Placeholders/greenFish.png")
const HOOK = preload("res://Assets/Placeholders/hook.png")
const ORANGE_FISH = preload("res://Assets/Placeholders/orangeFish.png")
const PURPLE_FISH = preload("res://Assets/Placeholders/purpleFish.png")
const RED_FISH = preload("res://Assets/Placeholders/redFish.png")
const YELLOW_FISH = preload("res://Assets/Placeholders/yellowFish.png")

const PUFFERFISH = preload("res://Assets/Placeholders/pufferfish.png")

const BIG_HOOK = preload("res://Assets/Placeholders/bigHook.png")
const BONUS = preload("res://Assets/Placeholders/bonus.png")
const FRENZY = preload("res://Assets/Placeholders/frenzy.png")
const SHEILD = preload("res://Assets/Placeholders/sheild.png")
const SLOWHOOK = preload("res://Assets/Placeholders/slowhook.png")
const SPEEDFISH = preload("res://Assets/Placeholders/speedfish.png")
const TRASH_1 = preload("res://Assets/Placeholders/trash1.png")
const TRASH_2 = preload("res://Assets/Placeholders/trash2.png")

var textures = {"blueFish":BLUE_FISH , "greenFish":GREEN_FISH , "orangeFish": ORANGE_FISH , "purpleFish":PURPLE_FISH , 
"redFish":RED_FISH , "yellowFish": YELLOW_FISH , "hook":HOOK , "pufferfish":PUFFERFISH ,
"sheild":SHEILD , "pslow":SLOWHOOK , "pfast":SPEEDFISH , "bonus":BONUS , "size":BIG_HOOK , "frenzy":FRENZY , "trash1":TRASH_1 ,
"trash2":TRASH_2}

var colors = [Color.RED , Color.DARK_ORANGE , Color.GOLD , Color.WEB_GREEN , Color.MEDIUM_BLUE , Color.WEB_PURPLE , Color.WEB_GRAY , Color.HOT_PINK]

func _process(delta: float) -> void:
	screen = DisplayServer.window_get_size()
