class_name PlayerStateFall
extends PlayerState

@export var fall_gravity_multiplier: float = 1.165

func enter() -> void:
	player.gravity_multiplier = fall_gravity_multiplier

func exit() -> void:
	player.gravity_multiplier = 1.0

func handle_inputs(event: InputEvent) -> PlayerState:
	if event.is_action_pressed("dash") and player.can_dash:
		return dash
		
	if event.is_action_pressed("jump"):
		player.buffer_input("jump")
	
	return next_state

func physics_process(_delta: float) -> PlayerState:
	player.velocity.x = player.direction.x * player.move_speed

	if player.is_on_floor():
		player.add_debug_indicator(Color.RED)
		if player.consume_jump_buffer():
			return jump
		return idle

	# Coyote jump check
	if Input.is_action_just_pressed("jump") and player.coyote_timer > 0:
		return jump

	return next_state
