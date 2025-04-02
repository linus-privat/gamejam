extends CharacterBody2D

signal shoot(pos_r,pos_l, direction)

enum {LEFT,LEFTUP,LEFTDOWN, RIGHT, RIGHTUP, RIGHTDOWN, UP, DOWN}
const max_speed = 200
const acceleration = 1800
const friction = 1800


@onready var animated_sprite = $AnimatedSprite2D
@onready var shoot_marker_right = $Node2D/GunSprite/ShootStartPosition/MarkerRight
@onready var shoot_marker_left = $Node2D/GunSprite/ShootStartPosition/MarkerLeft
@onready var shoot_timer = $ShootTimer

var input = Vector2.ZERO
var facing = DOWN
var moving = false
var mouse_pos = Vector2.ZERO
var shoot_dir = Vector2.ZERO
var shoot_timeout = false
var firerate = 0.01


func _physics_process(delta):
	# GLobal
	Globals.player_pos = global_position
	
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
	if Input.is_action_pressed("shoot"):
		var pos_right = shoot_marker_right.global_position
		var pos_left = shoot_marker_left.global_position
		if not shoot_timeout:
			shoot.emit(pos_right,pos_left, shoot_dir)
			shoot_timeout = true
			shoot_timer.start(firerate)
			print('shoot')
		
	
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
		LEFTUP:
			animated_sprite.play("p-idle-left-up")
		LEFTDOWN:
			animated_sprite.play("p-idle-left-down")
		RIGHTUP:
			animated_sprite.play("p-idle-right-up")
		RIGHTDOWN:
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
		LEFTUP:
			animated_sprite.play("p-walk-left-up")
		LEFTDOWN:
			animated_sprite.play("p-walk-left-down")
		RIGHTUP:
			animated_sprite.play("p-walk-right-up")
		RIGHTDOWN:
			animated_sprite.play("p-walk-right-down")
		
func set_facing(direction: Vector2) -> void:
	if not moving:
		return
	var dir = direction.normalized()
	var rounded = Vector2(round(dir.x), round(dir.y))

	match rounded:
		Vector2(1, 0):
			facing = RIGHT
		Vector2(1, 1):
			facing = RIGHTDOWN
		Vector2(0, 1):
			facing = DOWN
		Vector2(-1, 1):
			facing = LEFTDOWN
		Vector2(-1, 0):
			facing = LEFT
		Vector2(-1, -1):
			facing = LEFTUP
		Vector2(0, -1):
			facing = UP
		Vector2(1, -1):
			facing = RIGHTUP


func _on_shoot_timer_timeout() -> void:
	shoot_timeout = false
