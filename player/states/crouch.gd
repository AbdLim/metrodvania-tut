class_name PlayerStateCrouch
extends PlayerState

func enter() -> void:
#	Change sprite perhaps
	player.sprite_2d.scale.y = 0.7
	player.player_collider.disabled = true
	player.player_collider_crouch.disabled = false
	pass

func exit() -> void:
#	Revert the sprite
	player.sprite_2d.scale.y = 1.0
	player.player_collider.disabled = false
	player.player_collider_crouch.disabled = true
	pass

func handle_inputs(_event: InputEvent) -> PlayerState:
	if _event.is_action_pressed("jump") and Input.is_action_pressed("down"):
		if player.is_on_one_way_platform():
			return drop
		else:
			player.buffer_input("jump")
	if _event.is_action_released("down"):
		return idle
	return next_state

func physics_process(_delta: float) -> PlayerState:
	player.velocity.x = 0

	if not player.is_on_floor():
		return fall

	if player.consume_jump_buffer():
		return jump

	return next_state
