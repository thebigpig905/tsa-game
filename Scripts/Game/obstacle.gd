extends Sprite2D
var speed
var type
var time = 0
var initpos = 0

func _ready() -> void:
	var n = (randf() * 2) + 1
	scale = Vector2(n , n)
	initpos = position.y

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.get_parent().get_parent().get_parent().sheilded == false:
		body.hurt()
	else:
		body.get_parent().get_parent().get_parent().sheilded = false
		body.get_parent().get_parent().get_parent().get_child(8).play()
		

func _process(delta: float) -> void:
	if get_parent().get_parent().get_parent().get_parent().paused == false:
		time += delta
		position.y = (sin(time * 0.75) * 50) + initpos
func fish():
	pass #do not remove
