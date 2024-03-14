extends Sprite2D

var max_speed := 600.0
var velocity := Vector2(0, 0)
var boost_speed = 1500.0
var normal_speed = 600.0

func _process(delta: float) -> void:
	var direction := Vector2(0, 0)
	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis("move_up", "move_down")
	
	if Input.is_action_just_pressed("boost"):
		max_speed = boost_speed
		get_node("Timer").start()
	
	velocity = direction * max_speed 
	position += velocity * delta
	
	if direction.length() > 0.0:
		rotation = velocity.angle()
	
	if direction.length() > 1.0:
		direction = direction.normalized()
	

func _on_timer_timeout() -> void:
	max_speed = normal_speed
