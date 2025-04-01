extends CharacterBody2D

const max_speed = 400
const acceleration = 1500
const friction = 600

var input = Vector2.ZERO

func _physics_process(delta):
	player_movement(delta)
	
func player_movement(delta):
		input = Input.get_vector("walk left", "walk right", "walk up", "walk down")
		if input == Vector2.ZERO:
			if velocity.length() > (friction * delta):
				velocity -= velocity.normalized() * (friction * delta)
			else:
				velocity = Vector2.ZERO
		else:
			velocity += (input * acceleration * delta)
			velocity = velocity.limit_length(max_speed)
		move_and_slide()
				
