
extends CharacterBody2D


const SPEED = 110.0
const JUMP_VELOCITY = -270.0
var spawn_position: Vector2
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	#Flip Player
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	elif velocity.x>0:
		$AnimatedSprite2D.flip_h = false

	move_and_slide()

func _ready():
	spawn_position = global_position
	# Restore position if coming from another world
	if SceneManager.has_saved_position:
		global_position = SceneManager.player_position

func _process(delta):
	if Input.is_action_just_pressed("world1"):
		SceneManager.switch_world("res://Scenes/overworld.tscn", self)

	elif Input.is_action_just_pressed("world2"):
		SceneManager.switch_world("res://Scenes/powerstation.tscn", self)

	elif Input.is_action_just_pressed("world3"):
		SceneManager.switch_world("res://Scenes/arena.tscn", self)

func respawn():
	SceneManager.switch_world("res://Scenes/overworld.tscn", self, false)
