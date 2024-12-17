extends ColorRect

#signal for clicking
signal clicked()
#if mouse is in button area
var isin: bool = false

#detect clicks
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("clickL"):
		if isin:
			clicked.emit()

#sets isin when mouse enters/ exits
func _on_mouse_entered() -> void:
	isin = true


func _on_mouse_exited() -> void:
	isin = false
