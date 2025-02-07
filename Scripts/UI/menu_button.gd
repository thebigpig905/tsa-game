extends NinePatchRect
signal clicked(button)
var btnName: String
var isin: bool = false
var alt

func _ready() -> void:
	$Label.text = btnName #sets text on button to be the button name
	if alt != null:
		if btnName == "Switch Directions": #adds the key bound if the button is keybind button
			$Label.text += ": " + str(Global.switch[alt])
		if btnName == "Reel In Hook":
			$Label.text += ": " + str(Global.use[alt])
	if $Label.get_line_count() > 1: #sets smaller font size if text is too big for button
		$Label.add_theme_font_size_override("font_size" , 16)
	if $Label.text == "Next Round":
		$Label.add_theme_font_size_override("font_size" , 32)
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("clickL"): #if left clicked while in the button area emit the clicked signal
		if isin:
			clicked.emit(btnName)
	$Label.size = size / Vector2(2 , 2) #resizes text to be centered in the button
	

func _on_mouse_entered() -> void:
	isin = true #sets isin when mouse enters



func _on_mouse_exited() -> void:
	isin = false #sets isin when mouse exits
