extends ColorRect
signal clicked(button)
var btnName: String
var isin: bool = false
var alt

func _ready() -> void:
	$Label.text = btnName
	if alt != null:
		if btnName == "Switch Directions":
			$Label.text += ": " + str(Global.switch[alt])
		if btnName == "Use Item":
			$Label.text += ": " + str(Global.use[alt])
	if $Label.get_line_count() > 1:
		$Label.add_theme_font_size_override("font_size" , 16)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("clickL"):
		if isin:
			clicked.emit(btnName)
	$Label.size = size / Vector2(2 , 2)
	

func _on_mouse_entered() -> void:
	isin = true


func _on_mouse_exited() -> void:
	isin = false
