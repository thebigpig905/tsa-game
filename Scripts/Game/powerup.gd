extends CharacterBody2D

var type:String
const FISHES = ["blueFish" , "greenFish" , "orangeFish" , "purpleFish" , "redFish" , "yellowFish"]
var powers = ["sheild" , "pslow" , "pfast" , "bonus" , "size" , "frenzy" , "trash1" , "trash2"]
var dir:Vector2 = Vector2(0 , 0)
var speed = 50
var p = 1
var num:int

func _ready() -> void:
	num = randi_range(0 , powers.size() - 1)
	if type == "fish":
		$Sprite2D.texture = Global.textures[FISHES[randi_range(0 , FISHES.size() - 1)]]
		if randi_range(1 , 2) == 1:
			dir = Vector2(1 , 0)
		else:
			dir = Vector2(-1 , 0)
	
	if type == "power":
		$Sprite2D.texture = Global.textures[powers[num]]
		if powers[num] != "size":
			scale = Vector2(1.5 , 1.5)
		if int(powers[num]) != 0:
			speed = 25
			if randi_range(1 , 2) == 1:
				dir = Vector2(1 , 0)
			else:
				dir = Vector2(-1 , 0)
	
	if type == "bad":
		speed = 100
		$Sprite2D.texture = Global.PUFFERFISH
		scale = Vector2(1.5 , 1.5)
		if randi_range(1 , 2) == 1:
			dir = Vector2(1 , 0)
		else:
			dir = Vector2(-1 , 0)
		
func _physics_process(delta: float) -> void:
	velocity = speed * dir * p
	move_and_slide()
	if get_slide_collision_count() > 0:
		dir *= -1
	if dir.x == -1:
		$Sprite2D.flip_h = true
	elif dir.x == 1:
		$Sprite2D.flip_h = false
		
func fish(): #THIS IS NOT USELESS DO NOT DELETE
	pass
func upds():
	_ready()
