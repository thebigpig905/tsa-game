extends Sprite2D
var speed
var type

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.get_parent().get_parent().get_parent().sheilded == false:
		body.hurt()
	else:
		body.get_parent().get_parent().get_parent().sheilded = false

func fish():
	pass #do not remove
