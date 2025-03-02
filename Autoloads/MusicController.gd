extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func play_music():
	$Music.play()
	
func play_wind():
	$Wind.play()
	
func stop_music():
	$Music.stop()
	
func reset_music_volume():
	$Music.volume_db = 0
	
func fade_out_music():
	$AnimationPlayer.play("fade_music")
		
func fade_in_music():
	$AnimationPlayer.play_backwards("fade_music")
