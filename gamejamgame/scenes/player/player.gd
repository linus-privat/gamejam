extends CharacterBody2D

signal shoot(pos_r,pos_l, direction)

enum {LEFT,LEFTUP,LEFTDOWN, RIGHT, RIGHTUP, RIGHTDOWN, UP, DOWN}
const max_speed = 200
const acceleration = 1800
const friction = 1800

@onready var animated_sprite = $AnimatedSprite2D
@onready var shoot_marker_right = $Node2D/GunSprite/ShootStartPosition/MarkerRight
@onready var shoot_marker_left = $Node2D/GunSprite/ShootStartPosition/MarkerLeft

var input = Vector2.ZERO
var facing = DOWN
var moving = false
var mouse_pos
var shoot_dir


func _physics_process(delta):
	# movement
	player_movement(delta)
	mouse_pos = get_global_mouse_position()
	shoot_dir = (mouse_pos-global_position).normalized()
	if shoot_dir.x < 0:
		$Node2D/GunSprite.flip_v = true
	else:
		$Node2D/GunSprite.flip_v = false
	$Node2D.look_at(shoot_dir+global_position)
	
	# shoot input
	if Input.is_action_just_pressed("shoot"):
		var pos_right = shoot_marker_right.global_position
		var pos_left = shoot_marker_left.global_position
		print('shoot')
		shoot.emit(pos_right,pos_left, shoot_dir)
	
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
			animated_sprite.play("p-idle-up")
		DOWN:
			animated_sprite.play("p-idle")
		LEFT:
			animated_sprite.play("p-idle-left-down")
		RIGHT:
			animated_sprite.play("p-idle-right-down")

func player_animation_walk(dir):
	match facing:
		UP:
			animated_sprite.play("p-walk-up")
		DOWN:
			animated_sprite.play("p-walk")
		LEFT:
			animated_sprite.play("p-walk-left-down")
		RIGHT:
			animated_sprite.play("p-walk-right-down")
		
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


				
