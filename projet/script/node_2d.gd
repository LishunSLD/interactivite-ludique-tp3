extends Node2D

@onready var relic: Area2D = $Relic
@onready var player: CharacterBody2D = $Cercey

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass

var relicTriggered = false
var minouTriggered = false
var boxRoomTriggered = false
var hallwayTriggered = false

func _on_relic_body_entered(body: Node2D) -> void:
	if relicTriggered:
		return

	relicTriggered = true
	relic.hide()
	player.sfxPickup.play()
	player.dialogue.dialog("[b]Cercey[/b]", "Est-ce une relique?", 3)
	player.SPEED = 250.0


func _on_minou_head_body_entered(body: Node2D) -> void:
	if minouTriggered || body != player:
		return

	minouTriggered = true
	player.dialogue.dialog("[b]Cercey[/b]", "Huh?", 3)


func _on_box_room_body_entered(body: Node2D) -> void:
	if boxRoomTriggered || body != player:
		return

	boxRoomTriggered = true
	player.dialogue.dialog("[b]Cercey[/b]", "Cette salle contient des machines inutiles.", 3)


func _on_hallway_body_entered(body: Node2D) -> void:
	if hallwayTriggered || body != player:
		return

	hallwayTriggered = true
	player.dialogue.dialog("[b]Cercey[/b]", "C'est un long couloir.", 3)
