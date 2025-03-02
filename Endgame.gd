extends "res://Interaction Area.gd"

signal game_over

func _on_Interaction_Area_body_entered(body):
	emit_signal("player_stop_move")
	emit_signal("game_over")
	pass
