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

#keyboard keys
var keys = {'Escape': preload("res://Assets/KEYS/ESC.png") , 
'F1': preload('res://Assets/KEYS/F1.png') , 
'F2': preload('res://Assets/KEYS/F2.png') , 
'F3': preload('res://Assets/KEYS/F3.png') , 
'F4': preload('res://Assets/KEYS/F4.png') , 
'F5': preload('res://Assets/KEYS/F5.png') , 
'F6': preload('res://Assets/KEYS/F6.png') , 
'F7': preload('res://Assets/KEYS/F7.png') , 
'F9': preload('res://Assets/KEYS/F9.png') , 
'F10': preload('res://Assets/KEYS/F10.png') , 
'F11': preload('res://Assets/KEYS/F11.png') , 
'F12': preload('res://Assets/KEYS/F12.png') , 
'QuoteLeft': preload('res://Assets/KEYS/QUOTATIONMARKS.png') , 
'Tab': preload('res://Assets/KEYS/Tab.png') , 
'CapsLock': preload('res://Assets/KEYS/CAPS.png') , 
'Shift': preload('res://Assets/KEYS/Shift.png') , 
'Ctrl': preload('res://Assets/KEYS/Ctrl.png') , 
'Windows': preload('res://Assets/KEYS/Windows.png') , 
'Alt': preload('res://Assets/KEYS/Alt.png') , 
'Minus': preload('res://Assets/KEYS/-.png') , 
'Equal': preload('res://Assets/KEYS/=.png') , 
'Backspace': preload('res://Assets/KEYS/Backspace.png') , 
'BracketLeft': preload('res://Assets/KEYS/[.png') , 
'BracketRight': preload('res://Assets/KEYS/].png') , 
'BackSlash': preload('res://Assets/KEYS/BackSlash.png') , 
'Semicolon': preload('res://Assets/KEYS/Semicolon.png') , 
'Apostrophe': preload('res://Assets/KEYS/Apostrophe.png') , 
'Enter': preload('res://Assets/KEYS/Enter.png') , 
'Comma': preload('res://Assets/KEYS/Comma.png') , 
'Period': preload('res://Assets/KEYS/DOT.png') , 
'Slash': preload('res://Assets/KEYS/FORWARDSLASH.png') , 
'Menu': preload('res://Assets/KEYS/Menu.png') , 
'Print': preload('res://Assets/KEYS/Print.png') , 
'ScrollLock': preload('res://Assets/KEYS/ScrollLock.png') , 
'Pause': preload('res://Assets/KEYS/Pause.png') , 
'Insert': preload('res://Assets/KEYS/Insert.png') , 
'Home': preload('res://Assets/KEYS/Home.png') , 
'PageUp': preload('res://Assets/KEYS/PageUp.png') , 
'Delete': preload('res://Assets/KEYS/MAC.png') , 
'End': preload('res://Assets/KEYS/End.png') , 
'PageDown': preload('res://Assets/KEYS/PageDown.png') , 
'Left': preload('res://Assets/KEYS/ARROWLEFT.png') , 
'Up': preload('res://Assets/KEYS/ARROWUP.png') , 
'Down': preload('res://Assets/KEYS/ARROWDOWN.png') , 
'Right': preload('res://Assets/KEYS/ARROWRIGHT.png') , 
'NumLock': preload('res://Assets/KEYS/NUM.png') , 
'Kp Divide': preload('res://Assets/KEYS/FORWARDSLASH.png') , 
'Kp Multiply': preload('res://Assets/KEYS/STAR.png') , 
'Kp Subtract': preload('res://Assets/KEYS/-.png') , 
'Kp Add': preload('res://Assets/KEYS/+.png') , 
'Kp Enter': preload('res://Assets/KEYS/ENTER.png') , 
'Kp 0': preload('res://Assets/KEYS/0.png') , 
'Kp 1': preload('res://Assets/KEYS/1.png') , 
'Kp 2': preload('res://Assets/KEYS/2.png') , 
'Kp 3': preload('res://Assets/KEYS/3.png') , 
'Kp 4': preload('res://Assets/KEYS/4.png') , 
'Kp 5': preload('res://Assets/KEYS/5.png') , 
'Kp 6': preload('res://Assets/KEYS/6.png') , 
'Kp 7': preload('res://Assets/KEYS/7.png') , 
'Kp 8': preload('res://Assets/KEYS/8.png') , 
'Kp 9': preload('res://Assets/KEYS/9.png') , 
'1': preload('res://Assets/KEYS/1.png') , 
'2': preload('res://Assets/KEYS/2.png') , 
'3': preload('res://Assets/KEYS/3.png') , 
'4': preload('res://Assets/KEYS/4.png') , 
'5': preload('res://Assets/KEYS/5.png') , 
'6': preload('res://Assets/KEYS/6.png') , 
'7': preload('res://Assets/KEYS/7.png') , 
'8': preload('res://Assets/KEYS/8.png') , 
'9': preload('res://Assets/KEYS/9.png') , 
'0': preload('res://Assets/KEYS/0.png') , 
'Q': preload('res://Assets/KEYS/Q.png') , 
'W': preload('res://Assets/KEYS/W.png') , 
'E': preload('res://Assets/KEYS/E.png') , 
'R': preload('res://Assets/KEYS/R.png') , 
'T': preload('res://Assets/KEYS/T.png') , 
'Y': preload('res://Assets/KEYS/Y.png') , 
'U': preload('res://Assets/KEYS/U.png') , 
'I': preload('res://Assets/KEYS/I.png') , 
'O': preload('res://Assets/KEYS/O.png') , 
'P': preload('res://Assets/KEYS/P.png') , 
'A': preload('res://Assets/KEYS/A.png') , 
'S': preload('res://Assets/KEYS/S.png') , 
'D': preload('res://Assets/KEYS/D.png') , 
'F': preload('res://Assets/KEYS/F.png') , 
'G': preload('res://Assets/KEYS/G.png') , 
'H': preload('res://Assets/KEYS/H.png') , 
'J': preload('res://Assets/KEYS/J.png') , 
'K': preload('res://Assets/KEYS/K.png') , 
'L': preload('res://Assets/KEYS/L.png') , 
'Z': preload('res://Assets/KEYS/Z.png') , 
'X': preload('res://Assets/KEYS/X.png') , 
'C': preload('res://Assets/KEYS/C.png') , 
'V': preload('res://Assets/KEYS/V.png') , 
'B': preload('res://Assets/KEYS/B.png') , 
'N': preload('res://Assets/KEYS/N.png') , 
'M': preload('res://Assets/KEYS/M.png')}

#default colors used for the players/ scores
var colors = [Color.RED , Color.DARK_ORANGE , Color.GOLD , Color.WEB_GREEN , Color.MEDIUM_BLUE , Color.WEB_PURPLE , Color.WEB_GRAY , Color.HOT_PINK]

#update window size variable each frame
func _process(delta: float) -> void:
	screen = DisplayServer.window_get_size()
