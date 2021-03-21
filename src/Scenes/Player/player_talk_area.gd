extends Area2D

var talkable = false 
export(Resource) var _runtime_data = _runtime_data as RuntimeData
export(NodePath) onready var dialogue_box = get_node(dialogue_box) as Label
var newArea: Area2D

func _input(_event):
	_talking()


func _talking() -> void:
	if talkable and Input.is_action_just_pressed("Interact"):
		GameEvents.emit_signal("interact_clicked", newArea)
		talkable = false


func _on_area_entered(area):
	talkable = true
	newArea = area
	GameEvents.emit_signal("enable_dialogue_box", area)


func _on_area_exited(_area):
	talkable = false
	GameEvents.emit_signal("disable_dialogue_box")
