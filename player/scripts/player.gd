class_name Player extends CharacterBody2D

const DEBUG_JUMP_INDICATOR = preload("uid://buc1d0e7pxapv")

#region /// State machine variables
var states: Array[PlayerState] = []
var current_state: PlayerState:
	get: return states.front()
var previous_state: PlayerState:
	get: return states[1]
#endregion

@onready var sprite_2d: Sprite2D = $Sprite2D



#region /// Movement variables
var direction: Vector2 = Vector2.ZERO
var gravity_multiplier: float = 1.0
#endregion

#region /// Exported Variables
@export var move_speed: float = 150.0
@export var jump_velocity: float = 450.0
@export var gravity: float = 980.0
@export var coyote_time: float = 0.08
@export var jump_buffer_time: float = 0.12
@export var dash_cooldown: float = 0.25
#endregion

#region /// Timers
var coyote_timer: float = 0.0
var jump_buffer_timer: float = 0.0
var dash_cooldown_timer: float = 0.0
var drop_timer: float = 0.0
#endregion

func _ready() -> void:
	initialize_states()


func _unhandled_input(event: InputEvent) -> void:
	change_state(current_state.handle_inputs(event))


func _process(delta: float) -> void:
	update_direction()
	change_state(current_state.process(delta))


func _physics_process(delta: float) -> void:
	update_direction()
	update_timers(delta)
	apply_gravity(delta)
	move_and_slide()
	change_state(current_state.physics_process(delta))


#region /// state init
func initialize_states() -> void:
	states = []
	for c in $States.get_children():
		if c is PlayerState:
			states.append(c)
			c.player = self

	if states.size() == 0:
		return

	for state in states:
		state.init()

	change_state(states.front())
	current_state.enter()
	$Label.text = current_state.name
#endregion


#region /// state machine ctrl
func change_state(new_state: PlayerState) -> void:
	if new_state == null or new_state == current_state:
		return

	if current_state:
		current_state.exit()

	states.push_front(new_state)
	states.resize(3)
	current_state.enter()
	$Label.text = current_state.name
#endregion


#region /// direction + movement
func update_direction() -> void:
	var x_axis = Input.get_axis("left", "right")
	var y_axis = Input.get_axis("up", "down")
	direction = Vector2(x_axis, y_axis)
	if direction.x != 0:
		sprite_2d.scale.x = sign(direction.x)

func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		coyote_timer = max(0, coyote_timer - delta)
	else:
		coyote_timer = coyote_time

	velocity.y += gravity * delta * gravity_multiplier

func drop_down_through_platform() -> void:
	jump_buffer_timer = 0
	position.y += 1

func is_on_one_way_platform() -> bool:
	var _floor: KinematicCollision2D = get_last_slide_collision()
	if _floor and _floor.get_collider():
		return _floor.get_collider().collision_layer == 2
	return false

#endregion


#region /// timer + input buffering
func update_timers(delta: float) -> void:
	coyote_timer = max(0, coyote_timer - delta)
	jump_buffer_timer = max(0, jump_buffer_timer - delta)
	dash_cooldown_timer = max(0, dash_cooldown_timer - delta)

func buffer_input(action: String) -> void:
	if action == "jump":
		jump_buffer_timer = jump_buffer_time

func consume_jump_buffer() -> bool:
	if jump_buffer_timer > 0:
		jump_buffer_timer = 0
		return true
	return false
#endregion


#region /// utils
func add_debug_indicator(color: Color = Color.RED) -> void:
	var d: Node2D = DEBUG_JUMP_INDICATOR.instantiate()
	get_tree().root.add_child(d)
	d.global_position = global_position
	d.modulate = color
	await get_tree().create_timer(3.0).timeout
	d.queue_free()
#endregion
