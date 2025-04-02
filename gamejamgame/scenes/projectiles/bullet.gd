extends RigidBody2D

const speed = 800
const EXISTING_TIME = 5

func _ready() -> void:
	$DespawnTimer.start(EXISTING_TIME)


func _on_despawn_timer_timeout() -> void:
	queue_free()
