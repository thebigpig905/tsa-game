extends CharacterBody2D
#signals for powerup collecting and player hurt
signal power(type)
signal damaged

#held fish
var held: int = 0

#movement vars
var dir = Vector2(0 , 0)
var ext =Vector2 (1 , 1)
var speed = 150
var size: Vector2 = Vector2(16 , 30)

#important things
var plr:int
var p = 1 #p is 0 when game is paused to stop movement
var frenzy:bool = false #is frenzy active
var full = false #is player full
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	velocity = dir * speed * ext * p
	move_and_slide()

#check for entering bodies
func _on_area_2d_body_entered(body: Node2D) -> void:
	#if body fish
	if body.type == "fish":
		if !frenzy:
			if held < Global.settings["weight"]:
				get_parent().get_parent().get_parent().caught.emit(body.get_child(0).texture)
				full = false
				held += 1
				var score = Global.score.instantiate()
				score.t = "+1"
				score.g = "b"
				score.position = position
				get_parent().add_child(score)
				get_parent().get_parent().get_parent().fish_left -= 1
				for i in get_parent().get_parent().get_parent().fishes.size():
					if get_parent().get_parent().get_parent().fishes[i] == body:
						get_parent().get_parent().get_parent().fishes.remove_at(i)
						break
				for i in get_parent().get_children():
					if i == body:
						get_parent().remove_child(i)
						i.queue_free()
						break
			else:
				var score = Global.score.instantiate()
				score.t = "full"
				score.g = "b"
				score.position = position
				get_parent().add_child(score)
				full = true
		else:
			get_parent().get_parent().get_parent().caught.emit(body.get_child(0).texture)
			held += 1
			var score = Global.score.instantiate()
			score.t = "+1"
			score.g = true
			score.position = position
			get_parent().add_child(score)
			get_parent().get_parent().get_parent().fish_left -= 1 #subviewport -> container -> level
			for i in get_parent().get_parent().get_parent().fishes.size():
				if get_parent().get_parent().get_parent().fishes[i] == body:
					get_parent().get_parent().get_parent().fishes.remove_at(i)
					break
			for i in get_parent().get_children():
				if i == body:
					get_parent().remove_child(i)
					i.queue_free()
					break
	if body.type == "bad":
		if ! get_parent().get_parent().get_parent().sheilded:
			get_parent().get_parent().get_parent().get_child(5).play()
			Global.scores[plr] -= 250
			var score = Global.score.instantiate()
			score.t = "-250"
			score.g = false
			score.position = position
			get_parent().add_child(score)
			$"../../../border".visible = true
			$"../../../borderTime".start()
		else:
			get_parent().get_parent().get_parent().sheilded = false
			get_parent().get_parent().get_parent().get_child(7).play()
		for i in get_parent().get_parent().get_parent().fishes.size():
			if get_parent().get_parent().get_parent().fishes[i] == body:
				get_parent().get_parent().get_parent().fishes.remove_at(i)
				break
		for i in get_parent().get_children():
			if i == body:
				get_parent().remove_child(i)
				i.queue_free()
				break
			
	if body.type == "power":
		if body.num != 3:
			power.emit(body.powers[body.num])
					
			for i in get_parent().get_parent().get_parent().fishes.size():
				if get_parent().get_parent().get_parent().fishes[i] == body:
					get_parent().get_parent().get_parent().fishes.remove_at(i)
					break
			for i in get_parent().get_children():
				if i == body:
					get_parent().remove_child(i)
					i.queue_free()
					break
		else:
			if (held < Global.settings["weight"]) or frenzy:
				power.emit(body.powers[body.num])
					
				for i in get_parent().get_parent().get_parent().fishes.size():
					if get_parent().get_parent().get_parent().fishes[i] == body:
						get_parent().get_parent().get_parent().fishes.remove_at(i)
						break
				for i in get_parent().get_children():
					if i == body:
						get_parent().remove_child(i)
						i.queue_free()
						break


func _on_frenzy_timer_timeout() -> void:
	frenzy = false

func hurt():
	damaged.emit()
