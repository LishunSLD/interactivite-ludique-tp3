extends Node

var health: int = 10
var keys: int = 0
var speed: float = 0.0
var ammo: int = 5
var last_positions := {
	"game": Vector2.ZERO,
	"game2": Vector2.ZERO,
	"game3": Vector2.ZERO,
}

var relicTriggered = false
var minouTriggered = false
var boxRoomTriggered = false
var hallwayTriggered = false
var key1Triggered = false
var key2Triggered = false
var key1TriggeredStage2 = false
var key2TriggeredStage2 = false

var bossHealth: int = 100
