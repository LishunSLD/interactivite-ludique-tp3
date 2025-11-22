extends Control

func _on_jouer_pressed() -> void:
	get_tree().change_scene_to_file("./scenes/node_2d.tscn")
