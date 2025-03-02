extends "res://Interaction Area.gd"

var has_played_music

func _ready():
	has_interacted = false
	output_dialogue = "Third_Interaction"
	pass # Replace with function body.

func _on_Interaction_Area_body_entered(body):
	if not has_interacted:
		has_interacted = true
		emit_signal("player_stop_move")
		MusicController.fade_out_music()
	pass # Replace with function body.

func _on_Dialogue_Player_dialogue_finished():
	if has_interacted == true:
		emit_signal("player_can_move")
		yield(get_tree().create_timer(2), "timeout")
		if not has_played_music:
			has_played_music = true
			MusicController.reset_music_volume()
			MusicController.play_music()
	pass # Replace with function body.

func _on_Player_ready_for_scene():
	if has_interacted == true:
		emit_signal("dialogue_ready", output_dialogue)
