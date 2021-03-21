extends KinematicBody2D

var SPEED: int
export var RUN_SPEED = 80
export var WALK_SPEED = 20
export var ACCELERATION = 500

var velocity = Vector2.ZERO
onready var animation_player = get_node("AnimationPlayer")
onready var animation_tree = get_node("AnimationTree")
onready var animation_state = animation_tree.get("parameters/playback")

export(Resource) var _runtime_data = _runtime_data as RuntimeData

func _ready():
	animation_tree.active = true
	SPEED = RUN_SPEED

func _physics_process(delta):
	if _runtime_data.current_game_state == Enums.GameState.WALKING:
		_movement(delta)
	elif _runtime_data.current_game_state == Enums.GameState.IN_DIALOG:
		velocity = Vector2.ZERO
		SPEED = RUN_SPEED
		animation_state.travel("Idle")

func _movement(delta) -> void:
	var input_vector = Vector2.ZERO
	
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_vector.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		animation_tree.set("parameters/Idle/blend_position", input_vector)
		animation_tree.set("parameters/Run/blend_position", input_vector)
		animation_tree.set("parameters/Walk/blend_position", input_vector)
		animation_state.travel("Run")
		velocity = velocity.move_toward(input_vector * SPEED, ACCELERATION * delta)
		if Input.is_action_pressed("walk"):
			animation_state.travel("Walk")
			SPEED = WALK_SPEED
		elif Input.is_action_just_released("walk"):
			SPEED = RUN_SPEED
	else:
		animation_state.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, ACCELERATION * delta)

	velocity = move_and_slide(velocity)
