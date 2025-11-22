extends Node2D

@onready var relic: Area2D = $Relic
@onready var key1: Area2D = $Key1
@onready var key2: Area2D = $Key2
@onready var player: CharacterBody2D = $Cercey

@onready var stage1: Node2D = get_node("../Game")

var keys = 0
var key1TriggeredStage2 = false
var key2TriggeredStage2 = false

func _ready() -> void:
	if Global.speed > 0:
		player.SPEED = Global.speed

	if Global.keys > 0:
		keys = Global.keys

	if Global.last_positions["game2"] != Vector2.ZERO:
		player.global_position = Global.last_positions["game2"] + Vector2(0, 50)

	key1TriggeredStage2 = Global.key1TriggeredStage2
	key2TriggeredStage2 = Global.key2TriggeredStage2

	if Global.key1TriggeredStage2 == true:
		key1.hide()
	if Global.key2TriggeredStage2 == true:
		key2.hide()

func _process(delta: float) -> void:
	pass

func _on_key_1_body_entered(body: Node2D) -> void:
	if key1TriggeredStage2:
		return

	key1TriggeredStage2 = true
	Global.key1TriggeredStage2 = true
	key1.hide()
	player.sfxPickup.play()
	player.dialogue.dialog("[b]Cercey[/b]", "Est-ce une clef?", 3)
	keys = keys + 1
	Global.keys = keys


func _on_key_2_body_entered(body: Node2D) -> void:
	if key2TriggeredStage2:
		return

	key2TriggeredStage2 = true
	Global.key2TriggeredStage2 = true
	key2.hide()
	player.sfxPickup.play()
	player.dialogue.dialog("[b]Cercey[/b]", "Est-ce une clef?", 3)
	keys = keys + 1
	Global.keys = keys


func _on_door_body_entered(body: Node2D) -> void:
	if body != player:
		return

	if keys != 4:
		player.dialogue.dialog("[b]Cercey[/b]", "J'aurais besoin de 4 clefs.", 3)
		return
	
	Global.last_positions["game2"] = player.global_position
	get_tree().change_scene_to_file("././scenes/game3.tscn")


func _on_door_2_body_entered(body: Node2D) -> void:
	if body != player:
		return

	Global.last_positions["game2"] = player.global_position
	get_tree().change_scene_to_file("././scenes/game.tscn")
