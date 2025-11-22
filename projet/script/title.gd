extends Control

func _on_jouer_pressed() -> void:
	get_tree().change_scene_to_file("./scenes/game.tscn")

func _on_reglages_pressed() -> void:
	get_tree().change_scene_to_file("./scenes/reglages.tscn")
