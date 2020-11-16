extends KinematicBody2D

var yellow = "fdec66"
var green = "7feb92"
var red = "fb669a"
var blue = "a19eff"
var white = "cdcbbc"

var colors = [yellow, blue, red, green, white]

const ACCELERATION = 512
const MAX_SPEED = 64
const FRICTION = 0.3
const GRAVITY = 600
const JUMP_FORCE = 275
const AIR_FRICTION = 0.025

enum fairy {
	YLW,
	BLU,
	RED,
	GRN,
	NON
}

var belly = fairy.NON

var motion = Vector2.ZERO

func reset_belly():
	belly = fairy.NON
	$Light2D.color = colors[belly]
	$Light2D.scale = Vector2(1.1,1.1)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	var x_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	if x_input != 0:
		motion.x += x_input * ACCELERATION * delta
		motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
		if is_on_floor():
			$Frogo.animation = "run"
			$Area2D/CollisionShape2D.disabled = true
		if x_input > 0:
			if $Frogo.flip_h == true:
				$Frogo.position.x += 16
				$Frogo.flip_h = false
				$Area2D/CollisionShape2D.position.x = 12
		else:
			if $Frogo.flip_h == false:
				$Frogo.position.x -= 16
				$Frogo.flip_h = true
				$Area2D/CollisionShape2D.position.x = -13
	elif $Frogo.animation == "run":
		$Frogo.animation = "idle"
	
	motion.y += GRAVITY * delta;
	
	if is_on_floor():
		if $Frogo.animation == "jump":
			$Frogo.animation = "idle"
		if x_input == 0:
			motion.x = lerp(motion.x, 0, FRICTION)
		if Input.is_action_just_pressed("ui_up"):
			motion.y = -JUMP_FORCE
			$Frogo.animation = "jump"
			$Area2D/CollisionShape2D.disabled = true
		if Input.is_action_just_pressed("ui_down") and belly == fairy.NON:
			$Frogo.play("take")
			$Area2D/CollisionShape2D.disabled = false
			
	else:
		if Input.is_action_just_released("ui_up")\
		and motion.y < -JUMP_FORCE/2:
			motion.y = -JUMP_FORCE/2
		if x_input == 0:
			motion.x = lerp(motion.x, 0, AIR_FRICTION)
	
	motion = move_and_slide(motion, Vector2.UP)

func _on_Frogo_animation_finished():
	if $Frogo.animation == "take":
		$Area2D/CollisionShape2D.disabled = true
		$Frogo.animation = "idle"

func _on_Fairy_eaten(color):
	belly = color
	$Light2D.color = colors[belly]
	$Light2D.scale = Vector2(1.5,1.5)
