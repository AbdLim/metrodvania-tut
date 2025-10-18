@icon("res://player/states/state.svg")
class_name PlayerState
extends Node

@onready var idle: PlayerStateIdle = %Idle
@onready var run: PlayerStateRun = %Run
@onready var jump: PlayerStateJump = %Jump
@onready var fall: PlayerStateFall = %Fall
@onready var crouch: PlayerStateCrouch = %Crouch
@onready var drop: PlayerStateDrop = %Drop

var player: Player
var next_state: PlayerState = null

# Called once when states are initialized
func init() -> void:
	pass

# Called when entering the state
func enter() -> void:
	pass

# Called when exiting the state
func exit() -> void:
	pass

# Handle player input
func handle_inputs(_event: InputEvent) -> PlayerState:
	return null

# Called each process tick
func process(_delta: float) -> PlayerState:
	return null

# Called each physics tick
func physics_process(_delta: float) -> PlayerState:
	return null
