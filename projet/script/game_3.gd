extends Node2D

@onready var player: CharacterBody2D = $Cercey

@onready var stage1: Node2D = get_node("../Game")

var keys = 0

func _ready() -> void:
	player.SPEED = 50
	Global.health = 10
	Global.bossHealth = 50
		
	if Global.keys > 0:
		keys = Global.keys

func _on_lusin_body_entered(body: Node2D) -> void:
	if body != player:
		return

	player.dialogue.dialog("[b]Cercey[/b]", "Lusin?", 3)
	player.dialogue.dialog("[b]Lusin[/b]", "C'est toi, encore une fois..", 3)
	await get_tree().create_timer(6).timeout
	get_tree().change_scene_to_file("././scenes/lusinfight.tscn")


func _on_door_body_entered(body: Node2D) -> void:
	if body != player:
		return

	get_tree().change_scene_to_file("././scenes/game2.tscn")
