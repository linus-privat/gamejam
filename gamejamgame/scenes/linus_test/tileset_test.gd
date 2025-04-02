extends Node2D

class_name LevelParent

signal addtime(seconds)

var bullet_scene: PackedScene = preload("res://scenes/bullet.tscn")

func _on_player_shoot(pos, direction: Vector2) -> void:
	var bullet = bullet_scene.instantiate() as RigidBody2D
	bullet.position = pos
	bullet.linear_velocity = direction * bullet.speed
	print(direction)
	bullet.rotation = direction.angle()
	
	$Projectiles.add_child(bullet)
	
	addtime.emit(10)
	
