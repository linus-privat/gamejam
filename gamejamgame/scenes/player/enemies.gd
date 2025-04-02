extends CharacterBody2D

class_name EnemieParent

var active: bool = false
var speed: int = 0
var max_speed: int = 200
var speed_multiplier: int = 1

func _process(delta: float) -> void:
	if active:
		var direction = (Globals.player_pos - position).normalized()
		velocity = direction * speed * speed_multiplier
		
		move_and_collide(velocity * delta)

func _on_notice_area_body_entered(body: Node2D) -> void:
	print(body)
	active = true
	var tween = create_tween()
	tween.tween_property(self, "speed", max_speed, 6)
