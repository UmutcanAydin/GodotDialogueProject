extends KinematicBody2D

onready var dialogue_box = $NPCDialogueLabel
onready var interact_box = $ToTalkDialogue
onready var talk_area = $TalkArea
export(Resource) var _dialogue = _dialogue as Dialogue

func _ready():
	GameEvents.connect("enable_dialogue_box", self, "_enable_dialogue_box")
	GameEvents.connect("disable_dialogue_box", self, "_disable_dialogue_box")
	GameEvents.connect("interact_clicked", self, "_on_interact_clicked")
	
func _enable_dialogue_box(area):
	if area == talk_area:
		interact_box.visible = true

func _disable_dialogue_box():
	interact_box.visible = false


func _on_interact_clicked(area):
	if area == talk_area:
		interact_box.visible = false
		GameEvents.emit_dialog_initiated(_dialogue, dialogue_box)


