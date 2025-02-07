extends TextureRect
signal clicked()
var isin: bool = false

#these buttons are literally the same in the code
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("clickL"):
		if isin:
			clicked.emit()


func _on_mouse_entered() -> void:
	isin = true


func _on_mouse_exited() -> void:
	isin = false
