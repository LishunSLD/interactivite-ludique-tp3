extends CharacterBody2D

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var sfxFootstep: AudioStreamPlayer2D = $Footstep
@onready var sfxDialogue: AudioStreamPlayer2D = $Camera2D/Dialogue
@onready var sfxPickup: AudioStreamPlayer2D = $Pickup
@onready var dialogue: Camera2D = $Camera2D

var SPEED = 150.0

var directionName = "down";

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()

	var direction = Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down")
	)

	if direction != Vector2.ZERO:
		velocity = direction.normalized() * SPEED
	else:
		velocity = Vector2.ZERO

	if direction != Vector2.ZERO:
		sfxFootstep.play()
		if abs(direction.x) > abs(direction.y):
			if direction.x > 0:
				directionName = "right";
			else:
				directionName = "left";
		else:
			if direction.y < 0:
				directionName = "up";
			else:
				directionName = "down";
	
	if direction == Vector2.ZERO:
		if directionName == "up":
			animation.play("idle_up");
		else:
			animation.play("idle_down");
	else:
		animation.play("walk_" + directionName);

	move_and_slide()
