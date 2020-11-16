extends AnimatedSprite
signal eaten

var yellow = "fdec66"
var blue = "a19eff"
var green = "7feb92"
var red = "fb669a"

var colors = [yellow, blue, red, green]
export var color = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_change_color(new_color):
	color = new_color
	$Light2D.color = color

func _on_Area2D_area_entered(area):
	emit_signal("eaten", color)
	hide()

func _process(delta):
	$Light2D.color = colors[color]
