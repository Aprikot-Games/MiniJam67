extends Sprite
signal touch

var yellow = "fdec66"
var green = "7feb92"
var red = "fb669a"
var blue = "a19eff"
export var color = 0
var active = false
var colors = [yellow, blue, red, green]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_change_color(new_color):
	$Light2D.color = new_color

func _process(delta):
	if active == true:
		$Light2D.energy = 1
		$Light2D.scale = Vector2(10,10)
	else:
		$Light2D.energy = 0.75
		$Light2D.scale = Vector2(5,5)
	$Light2D.color = colors[color]

func _on_Area2D_body_entered(body):
	emit_signal("touch", color, self)
