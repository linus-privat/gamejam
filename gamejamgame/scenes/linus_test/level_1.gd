extends LevelParent

class_name Level1

func _on_player_shoot(pos_r,pos_l, direction: Vector2) -> void:
	var bullet = bullet_scene.instantiate() as RigidBody2D
	if direction.x <0:
		bullet.position = pos_l
	else:
		bullet.position = pos_r
	bullet.linear_velocity = direction * bullet.speed
	print(direction)
	bullet.rotation = direction.angle()
	
	$Projectiles.add_child(bullet)
	
	addtime.emit(10)
