extends Label
var t:String
var g #i hate this why did i not just make it an int. it is both a bool and a string

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = t
	#this code makes me sick
	if !g:
		add_theme_color_override("font_color" , Color.RED)
	if g:
		add_theme_color_override("font_color" , Color.GOLD)
	if g is not bool and g == "b":
		add_theme_color_override("font_color" , Color.WHITE)
	if g == null:
		add_theme_color_override("font_color" , Color.LIME_GREEN)
	position.x = clamp(position.x , 10 , Global.screen.x / Global.players - (size.x + 10))
	$Timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#text fade over time
	self_modulate = Color(1 , 1 , 1 , $Timer.time_left)

#delete on time end
func _on_timer_timeout() -> void:
	get_parent().remove_child(self)
	queue_free()
