extends CharacterBody2D

signal shoot(pos, input)

enum {LEFT, RIGHT, UP, DOWN}
const max_speed = 600
const acceleration = 2300
const friction = 1800

@onready var animation_player = $AnimationPlayer

var input = Vector2.ZERO
var facing = DOWN
var moving = false


func _physics_process(delta):
	# movement
	player_movement(delta)
	
	# shoot input
	if Input.is_action_just_pressed("shoot"):
		var pos = $ShootStartPosition/Marker2D.global_position
		print('shoot')
		shoot.emit(pos, input)
	
func player_movement(delta):
		input = Input.get_vector("walk left", "walk right", "walk up", "walk down")		
		moving = false
		if input == Vector2.ZERO:
			if velocity.length() > (friction * delta):
				velocity -= velocity.normalized() * (friction * delta)
			else:
				velocity = Vector2.ZERO
		else:
			moving = true
			set_facing(input)
			velocity += (input * acceleration)
			velocity = velocity.limit_length(max_speed)
		move_and_slide()
		
		if moving:
			player_animation_walk(facing)
		else:
			player_animation_idle(facing)

func player_animation_idle(dir):
	match facing:
		UP:
			animation_player.play("p-idle-up")
		DOWN:
			animation_player.play("p-idle")
		LEFT:
			animation_player.play("p-idle-left")
		RIGHT:
			animation_player.play("p-idle-right")

func player_animation_walk(dir):
	match facing:
		UP:
			animation_player.play("p-walk-up")
		DOWN:
			animation_player.play("p-walk")
		LEFT:
			animation_player.play("p-walk-left-down")
		RIGHT:
			animation_player.play("p-walk-right-down")
		
func set_facing(direction: Vector2) -> void:
	if not moving:
		return
	if abs(direction.x) >= abs(direction.y):
		if direction.x > 0:
			facing = RIGHT
			return
		facing = LEFT
		return
	if direction.y < 0:
		facing = UP
		return
	facing = DOWN


				
