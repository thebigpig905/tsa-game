extends CharacterBody2D
signal power(type)
signal damaged
var held: int = 0
var specials
var dir = Vector2(0 , 0)
var ext =Vector2 (1 , 1)
var speed = 150
var size: Vector2 = Vector2(16 , 30)
var plr:int
var p = 1
var frenzy:bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	velocity = dir * speed * ext * p
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.type == "fish":
		if !frenzy:
			if held < Global.settings["weight"]:
				held += 1
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
			held += 1
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
			Global.scores[plr] -= 250
		else:
			get_parent().get_parent().get_parent().sheilded = false
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
