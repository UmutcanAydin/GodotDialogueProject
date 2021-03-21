extends Area2D

export(Resource) var _dialogue = _dialogue as Dialogue

func _on_DialogueTrigger_body_entered(_body):
	GameEvents.emit_dialog_initiated(_dialogue, null)

func _on_DialogueTrigger_body_exited(_body):
	queue_free()
