extends Sprite2D
var speed
var type

func _ready() -> void:
	var n = (randf() * 2) + 1
	scale = Vector2(2 * n , 2 * n)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.get_parent().get_parent().get_parent().sheilded == false:
		body.hurt()
	else:
		body.get_parent().get_parent().get_parent().sheilded = false

func fish():
	pass #do not remove
