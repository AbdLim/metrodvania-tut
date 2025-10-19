class_name PlayerStateRun
extends PlayerState

func handle_inputs(event: InputEvent) -> PlayerState:
	if event.is_action_pressed("dash") and player.can_dash:
		return dash
	
	elif event.is_action_pressed("jump"):
		player.buffer_input("jump")
		
	return next_state

func process(_delta: float) -> PlayerState:
	if player.direction.x == 0:
		return idle
	return next_state

func physics_process(_delta: float) -> PlayerState:
	player.velocity.x = player.direction.x * player.move_speed

	if not player.is_on_floor():
		return fall

	if player.consume_jump_buffer():
		return jump

	return next_state
