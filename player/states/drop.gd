class_name PlayerStateDrop
extends PlayerState

@export var drop_time: float = 0.15

func enter() -> void:
	player.set_collision_mask_value(2, false)
	player.velocity.y = 50
	player.drop_timer = drop_time

func physics_process(_delta: float) -> PlayerState:
	player.drop_timer -= _delta
	
	if player.drop_timer <= 0:
		player.set_collision_mask_value(2, true)
		
		if player.is_on_floor():
			return idle
		return fall
	return next_state
