extends Control

onready var animation_player = find_node("AnimationPlayer")
onready var text_label = find_node("Text")
onready var dialogue_box = find_node("Dialogue Box")
onready var continue_icon = find_node("Continue_Icon")
onready var cue_player = find_node("Cue_Player")

signal dialogue_finished

var _did = 0
var _nid = 0
var _final_nid = 0
var story_reader
var _cue_library : Dictionary = {}

func _ready():
	var StoryReaderClass = load("res://addons/EXP-System-Dialog/Reference_StoryReader/EXP_StoryReader.gd")
	story_reader = StoryReaderClass.new()
	
	var story = load("res://Test_Open.tres")
	story_reader.read(story)
	
	_load_sound_cues()
	
	dialogue_box.visible = false
	continue_icon.visible = false
	
	#play_dialogue("Opening Dialogue")
	pass 
	
func _input(event):
	if event is InputEventKey:
		if event.is_action_pressed("advance_dialogue"):
			_on_Dialogue_Player_pressed_advance()
	pass
	
func _load_sound_cues():
	var did = story_reader.get_did_via_record_name("Sound Cues")
	var json_text = story_reader.get_text(did, 1)
	var raw_cue_library : Dictionary = parse_json(json_text)
	
	for key in raw_cue_library:
		var cue_path = raw_cue_library[key]
		var loaded_cue = load(cue_path)
		_cue_library[key] = loaded_cue
		
	
func _on_Dialogue_Player_pressed_advance():
	if _is_waiting():
		continue_icon.visible = false
		_get_next_node()
		if _is_playing():
			_play_node()
	pass
	
func _on_AnimationPlayer_animation_finished(anim_name):
	continue_icon.visible = true
	pass 
	
func play_dialogue(record_name):
	text_label.percent_visible = 0
	_did = story_reader.get_did_via_record_name(record_name)
	_nid = story_reader.get_nid_via_exact_text(_did, "<start>")
	_final_nid = story_reader.get_nid_via_exact_text(_did, "<end>")
	_get_next_node()
	_play_node()
	dialogue_box.visible = true
	pass
	
func _is_playing():
	return dialogue_box.visible
	pass
	
func _is_waiting():
	return continue_icon.visible
	pass
	
func _get_next_node():
	_nid = story_reader.get_nid_from_slot(_did, _nid, 0)
	
	if _nid == _final_nid:
		dialogue_box.visible = false
		text_label.clear()
		emit_signal("dialogue_finished")
	pass
	
func _play_node():
	text_label.text = ""
	var box_contents = story_reader.get_text(_did, _nid)
	var dialogue = _get_tagged_text("dialog", box_contents)
	
	text_label.bbcode_text = dialogue
	
	
	if "<music_cue>" in box_contents:
		var library_key = _get_tagged_text("music_cue", box_contents)
		_play_cue(library_key)

	animation_player.play("TextVisible")
	pass
	
func _play_cue(cue):
	cue_player.set_stream(_cue_library[cue])
	cue_player.play()

func _get_tagged_text(tag, contents):
	var start_tag = "<" + tag + ">"
	var end_tag = "</" + tag + ">"
	var start_index = contents.find(start_tag)+ start_tag.length()
	var end_index = contents.find(end_tag)
	var substr_length = end_index - start_index
	return contents.substr(start_index, substr_length)
	pass

func _on_Interaction_Area_dialogue_ready(output):
	play_dialogue(output)
	pass # Replace with function body.
