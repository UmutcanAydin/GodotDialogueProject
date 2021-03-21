extends KinematicBody2D

onready var player_detection_zone = $PlayerDetectionZone
onready var chase_controller = $ChaseController
onready var fight_initiater_coll = $FightZonePivot/FightZone/CollisionShape2D
onready var npc_dialogue_label = $NPCDialogueLabel

export var MAX_SPEED = 50
export var ACCELERATION = 500
export var CHASE_TARGET_RANGE = 5

onready var animation_player = get_node("AnimationPlayer")
onready var animation_tree = get_node("AnimationTree")
onready var animation_state = animation_tree.get("parameters/playback")

export(Resource) var _dialogue = _dialogue as Dialogue

export(Resource) var _runtime_data = _runtime_data as RuntimeData
enum {
	IDLE,
	WANDER,
	CHASE
}

var velocity = Vector2.ZERO
var state = CHASE

var controls_disabled = false

func _ready():
	GameEvents.connect("dialogue_finished", self, "_on_dialogue_finished")
	animation_tree.active = true

func _physics_process(delta):
	if !controls_disabled:
		match state:
			IDLE:
				velocity = velocity.move_toward(Vector2.ZERO, ACCELERATION)
				if _runtime_data.current_game_state == Enums.GameState.WALKING:
					_seek_player()
				animation_state.travel("Idle")
				if chase_controller.get_time_left() == 0:
					state = pick_random_state([IDLE,WANDER])
					chase_controller.start_timer(rand_range(1,3))
			WANDER:
				if _runtime_data.current_game_state == Enums.GameState.WALKING:
					_seek_player()
				if chase_controller.get_time_left() == 0:
					state = pick_random_state([IDLE,WANDER])
					chase_controller.start_timer(rand_range(1,3))
				var direction = global_position.direction_to(chase_controller.target_pos)
				animation_tree.set("parameters/Idle/blend_position", direction)
				animation_tree.set("parameters/Walk/blend_position", direction)
				animation_state.travel("Walk")
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
				if global_position.distance_to(chase_controller.target_pos) <= CHASE_TARGET_RANGE:
					state = pick_random_state([IDLE,WANDER])
					chase_controller.start_timer(rand_range(1,3))
			CHASE:
				var player = player_detection_zone.player
				if player != null and _runtime_data.current_game_state == Enums.GameState.WALKING:
					fight_initiater_coll.disabled = false
					animation_state.travel("Run")
					var direction = global_position.direction_to(player.global_position)
					animation_tree.set("parameters/Run/blend_position", direction)
					velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
				else: 
					fight_initiater_coll.disabled = true
					state = IDLE
		velocity = move_and_slide(velocity)


func _seek_player() -> void:
	if player_detection_zone.can_see_player():
		state = CHASE


func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()


func _on_FightZone_body_entered(_body):
	if _dialogue != null:
		controls_disabled = true
		animation_state.travel("Idle")
		GameEvents.emit_dialog_initiated(_dialogue,npc_dialogue_label)

func _on_dialogue_finished(dialogue_to_finish):
	if dialogue_to_finish == _dialogue:
		print("initiate fight")
