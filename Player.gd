extends KinematicBody2D

const ACCELERATION = 512
const MAX_SPEED = 64
const FRICTION = 0.3
const GRAVITY = 600
const JUMP_FORCE = 240
const AIR_FRICTION = 0.025

var motion = Vector2.ZERO
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	var x_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	if x_input != 0:
		motion.x += x_input * ACCELERATION * delta
		motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
		$Frogo.animation = "run"
		if x_input > 0:
			$Frogo.flip_h = false
		else:
			$Frogo.flip_h = true
	elif $Frogo.animation == "run":
		$Frogo.animation = "idle"
	
	motion.y += GRAVITY * delta;
	
	if is_on_floor():
		if x_input == 0:
			motion.x = lerp(motion.x, 0, FRICTION)
		if Input.is_action_just_pressed("ui_up"):
			motion.y = -JUMP_FORCE
		if Input.is_action_just_pressed("ui_down"):
			$Frogo.play("take")
	else:
		if Input.is_action_just_released("ui_up")\
		and motion.y < -JUMP_FORCE/2:
			motion.y = -JUMP_FORCE/2
		if x_input == 0:
			motion.x = lerp(motion.x, 0, AIR_FRICTION)
	
	motion = move_and_slide(motion, Vector2.UP)


func _on_Frogo_animation_finished():
	if $Frogo.animation != "idle":
		$Frogo.animation = "idle"
