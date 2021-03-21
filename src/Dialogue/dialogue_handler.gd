extends Control

export(NodePath) onready var _player_dialog_text = get_node(_player_dialog_text) as Label
export(NodePath) onready var _player_answer_control = get_node(_player_answer_control) as Control
var _npc_dialog_text: Label
var _current_dialogue: Resource = _current_dialogue as Dialogue
var _last_dialog_text: Label
export(Resource) var _runtime_data = _runtime_data as RuntimeData

var _current_slide_index: int = 0

func _ready():
	GameEvents.connect("dialogue_initiated", self, "_on_dialogue_initiated")
	GameEvents.connect("dialogue_finished", self, "_on_dialogue_finished")


func _input(_event):
	if _current_dialogue != null and Input.is_action_just_pressed("Interact"):
		if _current_slide_index < _current_dialogue.dialogue_slides.size() - 1:
			_current_slide_index += 1
			_show_slide()
		elif _current_dialogue.answers.size() > 0 and _current_slide_index == _current_dialogue.dialogue_slides.size() - 1:
			_show_answers()
		elif _runtime_data.current_game_state == Enums.GameState.IN_DIALOG:
			GameEvents.emit_dialog_finished()

func _show_answers() -> void:
	_player_answer_control.visible = true
	for answer in _current_dialogue.answers.size():
		_player_answer_control.get_child(answer).text = _current_dialogue.answers[answer].dialogue_slides[0]
		_player_answer_control.get_child(answer).set_dialogue(_current_dialogue.answers[answer])
		_player_answer_control.get_child(answer).set_npc_label(_npc_dialog_text)
		_player_answer_control.get_child(answer).visible = true
		_player_answer_control.get_child(0).grab_focus()
		
func _show_slide() -> void:
	if _current_dialogue.talker[_current_slide_index] == _player_dialog_text.name:
		if _npc_dialog_text != null:
			_npc_dialog_text.visible = false
		_player_dialog_text.visible = true
		_player_dialog_text.text = _current_dialogue.dialogue_slides[_current_slide_index]
		_last_dialog_text = _player_dialog_text
	elif _current_dialogue.talker[_current_slide_index] == _npc_dialog_text.name:
		_npc_dialog_text.visible = true
		_player_dialog_text.visible = false
		_npc_dialog_text.text = _current_dialogue.dialogue_slides[_current_slide_index]
		_last_dialog_text = _npc_dialog_text


func _on_dialogue_initiated(dialogue: Dialogue, dialogue_box: Label) -> void:
	if _runtime_data.current_game_state != Enums.GameState.IN_DIALOG:
		_runtime_data.current_game_state = Enums.GameState.IN_DIALOG
	_current_slide_index = 0
	_current_dialogue = dialogue
	if dialogue_box != null:
		_npc_dialog_text = dialogue_box
		if dialogue.talker[_current_slide_index] == _player_dialog_text.name:
			_player_dialog_text.visible = true
		elif dialogue.talker[_current_slide_index] == _npc_dialog_text.name:
			_player_dialog_text.visible = false
	else:
		_player_dialog_text.visible = true
	_show_slide()

func _on_dialogue_finished() -> void:
	_runtime_data.current_game_state = Enums.GameState.WALKING
	_last_dialog_text.visible = false