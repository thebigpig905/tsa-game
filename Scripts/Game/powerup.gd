extends CharacterBody2D

var type:String #type of object. fish bad or powerup

#texture names
const FISHES = ["blueFish" , "greenFish" , "orangeFish" , "purpleFish" , "redFish" , "yellowFish"]
var powers = ["sheild" , "pslow" , "pfast" , "bonus" , "size" , "frenzy" , "trash1" , "trash2"]
#velocity
var dir:Vector2 = Vector2(0 , 0)
var speed = 50
var p = 1
var num:int

func _ready() -> void:
	num = randi_range(0 , powers.size() - 1)
	#if fish set random direction and fish texture
	if type == "fish":
		$Sprite2D.texture = Global.textures[FISHES[randi_range(0 , FISHES.size() - 1)]]
		speed += get_parent().get_parent().get_parent().level * randi_range(15 , 45)
		if randi_range(1 , 2) == 1:
			dir = Vector2(1 , 0)
		else:
			dir = Vector2(-1 , 0)
	#if powerup set random power
	if type == "power":
		$Sprite2D.texture = Global.textures[powers[num]]
		if powers[num] != "size":
			scale *= Vector2(1.5 , 1.5)
		if powers[num] == "bonus":
			dir = Vector2(1 , 0)
		if int(powers[num]) != 0:
			speed = 25
			if randi_range(1 , 2) == 1:
				dir = Vector2(1 , 0)
			else:
				dir = Vector2(-1 , 0)
		if num > 5:
			$shiny1.queue_free()
			$shiny2.queue_free()
	else:
		$shiny1.queue_free()
		$shiny2.queue_free()
	if type == "bad":
		speed = 100
		if randi_range(1 , 2) == 2:
			$Sprite2D.texture = Global.PUFFERFISH
		else:
			$Sprite2D.texture = Global.JELLYFISH
		scale = Vector2(1.5 , 1.5)
		if randi_range(1 , 2) == 1:
			dir = Vector2(1 , 0)
		else:
			dir = Vector2(-1 , 0)
#update position and direction
func _physics_process(delta: float) -> void:
	if type == "power" and num < 6:
		$shiny1.rotation_degrees += 0.5
		$shiny2.rotation_degrees -= 0.5
	velocity = speed * dir * p
	move_and_slide()
	if get_slide_collision_count() > 0:
		dir *= -1
	if dir.x == -1:
		$Sprite2D.flip_h = true
	elif dir.x == 1:
		$Sprite2D.flip_h = false
		
func fish(): #THIS IS NOT USELESS DO NOT DELETE
	pass #this labels the node as a fish so that it can be deleted by other scripts
func upds():#redo the ready function if this needs to be reloaded for some reason
	_ready()
