extends Sprite2D
var dir = 0
var speed = randi_range(50 , 125)
var size = Vector2(16 , 0)
var bigfish = preload("res://Assets/Textures/bcgfsh2.png")
var fishsize = 16
var p = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if randi_range(0 , 1) == 0:
		dir = -1
	else:
		dir = 1
	if randi_range(0 , 9) == 0:
		texture = bigfish
		fishsize = 36
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if get_parent().get_parent().get_parent().get_parent().paused == true:
		p = 0
	else:
		p = 1
	if position.x > size.y - fishsize:
		dir = -1
	if position.x < size.x + fishsize:
		dir = 1
	position.x += dir * speed * 0.01 * p
	if dir == -1:
		flip_h = true
	else:
		flip_h = false
	
