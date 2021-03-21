extends Button

var dialogue = dialogue as Dialogue setget set_dialogue
var npc_label: Label setget set_npc_label

func set_dialogue(value):
	dialogue = value

func set_npc_label(value):
	npc_label = value
	
func _on_Button2_button_up():
	get_parent().visible = false
	GameEvents.emit_dialog_initiated(dialogue, npc_label)
