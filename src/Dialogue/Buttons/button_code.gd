extends Button

var dialogue = dialogue as Dialogue setget set_dialogue
var npc_label: Label setget set_npc_label

func set_dialogue(value):
	dialogue = value

func set_npc_label(value):
	npc_label = value
	
func _on_button_up():
	get_parent().visible = false
	GameEvents.emit_signal("answer_given", dialogue, npc_label)
