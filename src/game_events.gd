extends Node

signal enable_dialogue_box
signal disable_dialogue_box

signal interact_clicked
signal dialogue_initiated
signal dialogue_finished

signal answer_given

func emit_dialog_initiated(dialogue: Dialogue, dialogue_box: Label) -> void:
	call_deferred("emit_signal","dialogue_initiated", dialogue, dialogue_box)

func emit_dialog_finished(_current_dialogue: Dialogue) -> void:
	call_deferred("emit_signal", "dialogue_finished", _current_dialogue)
