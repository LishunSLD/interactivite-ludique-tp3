extends Node2D

@onready var relic: Area2D = $Relic
@onready var key1: Area2D = $Key1
@onready var key2: Area2D = $Key2
@onready var player: CharacterBody2D = $Cercey

var keys = 0
var relicTriggered = false
var minouTriggered = false
var boxRoomTriggered = false
var hallwayTriggered = false
var key1Triggered = false
var key2Triggered = false

func _ready() -> void:
	if Global.speed > 0:
		player.SPEED = Global.speed

	if Global.keys > 0:
		keys = Global.keys
		
	if Global.last_positions["game"] != Vector2.ZERO:
		player.global_position = Global.last_positions["game"] + Vector2(0, 50)

	relicTriggered = Global.relicTriggered
	key1Triggered = Global.key1Triggered
	key2Triggered = Global.key2Triggered

	if Global.relicTriggered == true:
		relic.hide()
	if Global.key1Triggered == true:
		key1.hide()
	if Global.key2Triggered == true:
		key2.hide()
		
	player.dialogue.dialog("[b]Cercey[/b]", "Quel genre de passage caché est-ce ?", 3)
	player.dialogue.dialog("[b]Cercey[/b]", "Maintenant, à la recherche du Comte.", 3)
	player.dialogue.dialog("[b]Cercey[/b]", "Où est-il?", 2)

func _on_relic_body_entered(body: Node2D) -> void:
	if relicTriggered:
		return

	relicTriggered = true
	relic.hide()
	player.sfxPickup.play()
	player.dialogue.dialog("[b]Cercey[/b]", "Est-ce une relique?", 3)
	player.SPEED = 250.0
	Global.speed = player.SPEED
	Global.relicTriggered = true


func _on_minou_head_body_entered(body: Node2D) -> void:
	if minouTriggered || body != player:
		return

	minouTriggered = true
	Global.relicTriggered = true
	player.dialogue.dialog("[b]Cercey[/b]", "Huh?", 3, true)


func _on_box_room_body_entered(body: Node2D) -> void:
	if boxRoomTriggered || body != player:
		return

	boxRoomTriggered = true
	Global.boxRoomTriggered = true
	player.dialogue.dialog("[b]Cercey[/b]", "Cette salle contient des machines inutiles.", 3)


func _on_hallway_body_entered(body: Node2D) -> void:
	if hallwayTriggered || body != player:
		return

	hallwayTriggered = true
	Global.hallwayTriggered = true
	player.dialogue.dialog("[b]Cercey[/b]", "C'est un long couloir.", 3)


func _on_key_1_body_entered(body: Node2D) -> void:
	if key1Triggered:
		return

	key1Triggered = true
	Global.key1Triggered = true
	key1.hide()
	player.sfxPickup.play()
	player.dialogue.dialog("[b]Cercey[/b]", "Est-ce une clef?", 3)
	keys = keys + 1
	Global.keys = keys


func _on_key_2_body_entered(body: Node2D) -> void:
	if key2Triggered:
		return

	key2Triggered = true
	Global.key2Triggered = true
	key2.hide()
	player.sfxPickup.play()
	player.dialogue.dialog("[b]Cercey[/b]", "Est-ce une clef?", 3)
	keys = keys + 1
	Global.keys = keys


func _on_door_body_entered(body: Node2D) -> void:
	if body != player:
		return
		
	if keys < 2 :
		player.dialogue.dialog("[b]Cercey[/b]", "J'aurais besoin de 2 clefs.", 3)
		return
	
	Global.last_positions["game"] = player.global_position
	get_tree().change_scene_to_file("././scenes/game2.tscn")
