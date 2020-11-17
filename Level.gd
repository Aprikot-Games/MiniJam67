extends Node2D

var progress = 0
var fairies = [$Fairy1]
var win = false
# Called when the node enters the scene tree for the first time.

func _process(delta):
	$Background.position = $Player/Camera2D.get_camera_position() - Vector2(160, 100)
	if progress >= 4:
		print("Complete!")
		progress = 0
		win = true
		$CanvasLayer/Label.show()
		$Timer.start()

func _on_Monolith_touch(color, monolith):
	if color == $Player.belly:
		monolith.active = true
		$Player.reset_belly()
		$Twinkle.play()
		progress += 1


func _on_VisibilityNotifier2D2_screen_exited():
	if win == false:
		get_tree().reload_current_scene()

func _on_Timer_timeout():
	get_tree().reload_current_scene()
