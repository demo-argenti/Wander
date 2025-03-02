extends KinematicBody2D

const ACCELERATION = 512
const SPEED = 85
const FRICTION = 20
const GRAVITY = 12
const JUMP_FORCE = 280
const AIR_RESISTANCE = 0.02

var can_coyote = true
var jump_pressed = false
var _end_of_game = false
var motion = Vector2.ZERO

enum direction_state{
	RIGHT = 1, LEFT = -1
}

enum in_air_state{
	GROUND, AIR
}

enum fall_state{
	FALL, JUMP
}

enum movement_state{
	IDLE, RUN
}

var direction = direction_state.RIGHT
var attempt_move = false
var can_move = false
var is_moving = false
var _scene_playing = false
var interactable
var _my_delta

onready var sprite = $Sprite
onready var animationTree =$AnimationTree

signal ready_for_scene

func _ready():
	$AnimationTree.active = true

func set_move(move_bool):
	can_move = move_bool
	
func get_can_move():
	return can_move
	
func _fixed_proces(delta):
	_my_delta = delta
	
func _physics_process(delta):
	move(delta)
	
#animation functions
func move(delta):
	var x_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	if x_input != 0 and can_move:
		attempt_move = true
		is_moving = true
		motion.x  = x_input*SPEED
		
		$AnimationTree.set("parameters/Run/blend_position", x_input)
		$AnimationTree.set("parameters/Idle/blend_position", x_input)
		$AnimationTree.set("parameters/Jump/blend_position", x_input)
		$AnimationTree.set("parameters/Fall/blend_position", x_input)
	else:
		attempt_move = false
		

	if Input.is_action_just_pressed("jump") and can_move:
		jump_pressed = true
		remember_jump_time()
		if can_coyote:
			motion.y = -JUMP_FORCE
			is_moving = true
			_jump_anim()
			
			
	if is_on_floor():
		can_coyote = true
		
		if jump_pressed and can_move:
			is_moving = true
			_jump_anim()
			motion.y = -JUMP_FORCE
			can_coyote = false
		else:
			if attempt_move:
				_run_anim()
			else:
				motion.x = 0
				is_moving = false
				_idle_anim()
			
		if x_input == 0:
			motion.x = lerp(motion.x, 0, FRICTION*delta)
	else:
		if Input.is_action_just_released("jump") and motion.y < -JUMP_FORCE/2 and can_move:
			motion.y = -JUMP_FORCE/2
		motion.x = lerp(motion.x, 0, AIR_RESISTANCE*delta)
		motion.y += GRAVITY
		
		if motion.y > 100:
			_fall_anim()
		coyote_time()
			
	if not can_move and not is_moving and not _scene_playing and not _end_of_game:
		_scene_playing = true
		yield(get_tree().create_timer(2), "timeout")
		emit_signal("ready_for_scene")
		
	motion = move_and_slide(motion, Vector2.UP)

func _run_anim():
	$AnimationTree.set("parameters/in_air_state/current",in_air_state.GROUND)
	$AnimationTree.set("parameters/movement_state/current", movement_state.RUN)
	
func _idle_anim():
	$AnimationTree.set("parameters/in_air_state/current",in_air_state.GROUND)
	$AnimationTree.set("parameters/movement_state/current", movement_state.IDLE)
	
func _jump_anim():
	$AnimationTree.set("parameters/in_air_state/current",in_air_state.AIR)
	$AnimationTree.set("parameters/fall_state/current", fall_state.JUMP)

func _fall_anim():
	$AnimationTree.set("parameters/in_air_state/current",in_air_state.AIR)
	$AnimationTree.set("parameters/fall_state/current", fall_state.FALL)

#jump Timers
func coyote_time():
	yield(get_tree().create_timer(.1), "timeout")
	can_coyote = false
	
func remember_jump_time():
	yield(get_tree().create_timer(.1), "timeout")
	jump_pressed = false
	
#signal receivers
func _on_Interaction_Area_player_stop_move():
	can_move = false
	pass # Replace with function body.

func _player_can_move():
	if _scene_playing:
		_scene_playing = false
	can_move = true
	pass # Replace with function body.


func _on_Endgame_game_over():
	_end_of_game = true
	pass # Replace with function body.
