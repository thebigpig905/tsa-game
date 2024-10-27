extends CharacterBody2D
var held: int = 0
var specials
var dir = Vector2(0 , 0)
var ext =Vector2 (1 , 1)
var speed = 150
var size: Vector2 = Vector2(16 , 30)
var plr:int
var p = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	velocity = dir * speed * ext * p
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.type == "fish":
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
			
	if body.type == "power":
		pass
