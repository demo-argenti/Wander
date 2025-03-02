extends "res://Interaction Area.gd"

func _ready():
	has_interacted = false
	output_dialogue = "Final Interaction"

func _on_Interaction_Area_body_entered(body):
	if not has_interacted:
		has_interacted = true
		emit_signal("player_stop_move")
		MusicController.fade_out_music()
	pass # Replace with function body.

func _on_Dialogue_Player_dialogue_finished():
	if has_interacted == true:
		emit_signal("player_can_move")
	pass # Replace with function body.

func _on_Player_ready_for_scene():
	if has_interacted == true:
		emit_signal("dialogue_ready", output_dialogue)
