extends CharacterBody2D
var target
var specials
var dir = Vector2(0 , 0)
var speed = 150
var size: Vector2 = Vector2(16 , 30)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	velocity = dir * speed
	move_and_slide()
