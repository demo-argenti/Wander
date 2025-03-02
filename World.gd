extends Node2D

signal can_move

func _ready():
	opening_scene()
	pass # Replace with function body.

func opening_scene():
	$CanvasLayer/ColorRect.color = Color( 0, 0, 0, 1 )
	$CanvasLayer/ColorRect/Thanks.modulate = Color(255, 255, 255, 0)
	MusicController.play_wind()
	yield(get_tree().create_timer(1), "timeout")
	$CanvasLayer/AnimationPlayer.play("AuthorFade")
	yield(get_tree().create_timer(5), "timeout")
	$CanvasLayer/AnimationPlayer.play_backwards("AuthorFade")
	yield(get_tree().create_timer(3), "timeout")
	$CanvasLayer/AnimationPlayer.play("TitleCardFade")
	yield(get_tree().create_timer(7), "timeout")
	$CanvasLayer/AnimationPlayer.play_backwards("TitleCardFade")
	yield(get_tree().create_timer(3), "timeout")
	$CanvasLayer/AnimationPlayer.play("Fader")
	yield(get_tree().create_timer(2.5), "timeout")
	emit_signal("can_move")

func _on_Endgame_game_over():
	$CanvasLayer/AnimationPlayer.play_backwards("Fader")
	yield(get_tree().create_timer(4), "timeout")
	$CanvasLayer/AnimationPlayer.play("AuthorFade")
	yield(get_tree().create_timer(5), "timeout")
	$CanvasLayer/AnimationPlayer.play_backwards("AuthorFade")
	yield(get_tree().create_timer(3), "timeout")
	$CanvasLayer/AnimationPlayer.play("TitleCardFade")
	yield(get_tree().create_timer(7), "timeout")
	$CanvasLayer/AnimationPlayer.play_backwards("TitleCardFade")
	yield(get_tree().create_timer(3), "timeout")
	$CanvasLayer/AnimationPlayer.play_backwards("ThanksFade")
	pass # Replace with function body.
	pass # Replace with function body.
