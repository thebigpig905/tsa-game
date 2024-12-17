extends ColorRect
signal clicked()
var isin: bool = false
#just another button script, why did i not just use one

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("clickL"):
		if isin:
			clicked.emit()


func _on_mouse_entered() -> void:
	isin = true


func _on_mouse_exited() -> void:
	isin = false
