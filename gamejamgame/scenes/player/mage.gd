extends EnemieParent

var attack = false

func _process(delta: float) -> void:
	if active: 
		$Movement.play("idle")
		var direction = (Globals.player_pos - position).normalized()
		velocity = direction * speed * speed_multiplier
		move_and_collide(velocity * delta)
	if attack:
		$DamageArea.global_position = Globals.player_pos
		$DamageArea.visible = true
		$DamageArea/Attack.play("attack")
	else:
		$DamageArea.visible = false
		
func _on_attack_trigger_body_entered(body: Node2D) -> void:
	self.active = false
	self.attack = true

func _on_attack_trigger_body_exited(body: Node2D) -> void:
	self.active = true
	self.attack = false
