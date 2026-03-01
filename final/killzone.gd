extends Area2D

@onready var timer: Timer = $Timer
var is_killing := false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not is_killing:
		is_killing = true
		print("You died!")
		Engine.time_scale = 0.5
		timer.start()

func _on_timer_timeout() -> void:
	Engine.time_scale = 1
	
	var player = get_tree().get_first_node_in_group("player")
	player.respawn()
	
	is_killing = false
