class_name PlayerStateDash
extends PlayerState

@export var dash_speed: float = 900.0
@export var dash_time: float = 0.15

var timer: float = 0.0
var started_on_ground: bool = false
var dash_direction: int = 1

func enter() -> void:
	started_on_ground = player.is_on_floor()
	dash_direction = player.facing if player.facing != 0 else 1

	player.can_dash = false
	player.dash_cooldown_timer = player.dash_cooldown

	player.velocity.x = float(dash_direction) * dash_speed

	timer = 0.0

func exit() -> void:
	# ensure gravity multiplier restored
	player.gravity_multiplier = 1.0

func handle_inputs(_event: InputEvent) -> PlayerState:
	# ignore inputs while dashing (locked)
	return null

func physics_process(_delta: float) -> PlayerState:
	timer += _delta

	player.velocity.x = float(dash_direction) * dash_speed
	player.velocity.y = 0.0

	if timer >= dash_time:
		# soften horizontal momentum on exit
		player.velocity.x *= 0.4

		if player.is_on_floor():
			if abs(player.direction.x) > 0:
				return run
			else:
				return idle
		return fall

	return null
