extends Node

var players: int = 2 #number of players

#preload all the scenes to be used in game
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
var backgroundfish = preload("res://Scenes/backgroundfish.tscn")
var title = preload("res://Scenes/title.tscn")
var cred = preload("res://Scenes/credits.tscn")
#Player info
var playerNames = ["Player 1" , "Player 2"]
var col = [0 , 1]
var scores = []
var total = []

#player controls and default controls
var switch = ["Q" , "O" , "Left" , "Kp 5"]
var use = ["W" , "P" , "Right" , "Kp 6"]
var switchDef = ["Q" , "O" , "Left" , "Kp 5"]
var useDef = ["W" , "P" , "Right" , "Kp 6"]

#game settings
var settings = {"rounds": 3 , "powerups": true , "lives": 5 , "timer": 90 , "weight": 5 , "length": 2}
var settingsDef = {"rounds": 3 , "powerups": true , "lives": 5 , "timer": 90 , "weight": 5 , "length": 2}

#game window size
var screen:Vector2 = DisplayServer.window_get_size()

#pfp stuff
var pfps = [preload("res://Assets/Textures/player icon background0.png") , preload("res://Assets/Textures/scuba sam0.png") , preload("res://Assets/Textures/patrick0.png") , preload("res://Assets/Textures/arg0.png")]
var playerps = [0 , 0]
#preload textures
const BLUE_FISH = preload("res://Assets/Textures/new fish0.png")
const GREEN_FISH = preload("res://Assets/Textures/fish green0.png")
const HOOK = preload("res://Assets/Placeholders/hook.png")
const ORANGE_FISH = preload("res://Assets/Textures/fish green0.png")
const PURPLE_FISH = preload("res://Assets/Textures/starfish0.png")
const RED_FISH = preload("res://Assets/Textures/fish red0.png")
const YELLOW_FISH = preload("res://Assets/Placeholders/yellowFish.png")

const JELLYFISH = preload("res://Assets/Textures/jellyfish0.png")
const PUFFERFISH = preload("res://Assets/Textures/pufferfish0.png")

const BIG_HOOK = preload("res://Assets/Placeholders/bigHook.png")
const BONUS = preload("res://Assets/Textures/fish golden0.png")
const FRENZY = preload("res://Assets/Textures/fishing frenzy0.png")
const SHEILD = preload("res://Assets/Textures/shield0.png")
const SLOWHOOK = preload("res://Assets/Textures/slow down0.png")
const SPEEDFISH = preload("res://Assets/Textures/speed up0.png")
const TRASH_1 = preload("res://Assets/Textures/rusty can obstacle0.png")
const TRASH_2 = preload("res://Assets/Placeholders/trash2.png")

const CORAL = preload("res://Assets/Textures/coral obstacle0.png")
const CRATE = preload("res://Assets/Textures/crate obstacle0.png")

#one dictionary to access the textures easier
var textures = {"blueFish":BLUE_FISH , "greenFish":GREEN_FISH , "orangeFish": ORANGE_FISH , "purpleFish":PURPLE_FISH , 
"redFish":RED_FISH , "yellowFish": YELLOW_FISH , "hook":HOOK , "pufferfish":PUFFERFISH ,
"sheild":SHEILD , "pslow":SLOWHOOK , "pfast":SPEEDFISH , "bonus":BONUS , "size":BIG_HOOK , "frenzy":FRENZY , "trash1":TRASH_1 ,
"trash2":TRASH_2}

#default colors used for the players/ scores
var colors = [Color.RED , Color.DARK_ORANGE , Color.GOLD , Color.WEB_GREEN , Color.MEDIUM_BLUE , Color.WEB_PURPLE , Color.WEB_GRAY , Color.HOT_PINK]

#update window size variable each frame
func _process(delta: float) -> void:
	screen = DisplayServer.window_get_size()
