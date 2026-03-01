
extends CharacterBody2D

var is_teleporting: bool = false

const SPEED = 110.0
const JUMP_VELOCITY = -270.0
var spawn_position: Vector2
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	if is_teleporting:
		return
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
	sprite.scale = Vector2(1.0,1.0)
	spawn_position = global_position
	# Restore position if coming from another world
	if SceneManager.has_saved_position:
		global_position = SceneManager.player_position

func _process(delta):
	if is_teleporting:
		return

	if Input.is_action_just_pressed("world1"):
		trigger_teleport("res://Scenes/overworld.tscn")
	elif Input.is_action_just_pressed("world2"):
		trigger_teleport("res://Scenes/powerstation.tscn")
	elif Input.is_action_just_pressed("world3"):
		trigger_teleport("res://Scenes/arena.tscn")

func respawn():
	SceneManager.switch_world("res://Scenes/overworld.tscn", self, false)

func trigger_teleport(target_scene: String):
	is_teleporting = true
	velocity = Vector2.ZERO
	
	# Shrink the sprite to half size (adjust these numbers to whatever looks best!)
	sprite.scale = Vector2(0.25, 0.25)
	
	sprite.play("portal")
	
	await sprite.animation_finished
	
	SceneManager.switch_world(target_scene, self)
