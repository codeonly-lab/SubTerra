extends Node

var player_position: Vector2 = Vector2.ZERO
var has_saved_position: bool = false

func switch_world(scene_path: String, player: Node2D, save_position: bool = true):
	if save_position and get_tree().current_scene.scene_file_path == scene_path:
		return
	
	if save_position:
		# Normal world switch: save coordinates
		player_position = player.global_position
		has_saved_position = true
	else:
		# Respawn: clear the saved position so the player spawns at the default level start
		has_saved_position = false
	
	# Switch scene
	get_tree().change_scene_to_file(scene_path)
