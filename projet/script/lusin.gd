extends Node2D

@export var bullet_scene: PackedScene
@export var ally_bullet_scene: PackedScene
@export var move_speed: float = 100.0
@export var shoot_interval: float = 1.0
@export var ally_bullet_count: int = 5
@export var ally_respawn_delay: float = 1.0
@export var arena_width: float = 800
@export var arena_height: float = 600

var shoot_timer: float = 0.0
var move_target: Vector2
var ally_bullets: Array = []
var respawn_timer: float = 0.0
var pattern_timer: float = 0.0
var pattern_type: int = 0

@onready var player = get_parent().get_node("Cercey")
@onready var shadersMat: ShaderMaterial = $Sprite2D.material
@onready var sfxShoot: AudioStreamPlayer2D = $Shoot

func _ready():
	player.SPEED = 160
	choose_new_target()

func _process(delta):
	if Global.bossHealth <= 0:
		get_tree().change_scene_to_file("./scenes/win.tscn")
		return

	move_boss(delta)

	shoot_timer += delta
	pattern_timer += delta

	if shoot_timer >= shoot_interval:
		shoot_timer = 0
		sfxShoot.play()
		shoot_attack_pattern()

	if pattern_timer >= 5.0:
		pattern_timer = 0
		pattern_type = randi() % 3

	if ally_bullets.size() == 0 and respawn_timer <= 0:
		spawn_ally_bullets()
	elif ally_bullets.size() > 0:
		var all_picked = true
		for b in ally_bullets:
			if b and b.is_inside_tree() and not b.picked_up:
				all_picked = false
				break
		if all_picked:
			ally_bullets.clear()
			respawn_timer = ally_respawn_delay

	if respawn_timer > 0:
		respawn_timer -= delta

func move_boss(delta):
	if move_target == null:
		choose_new_target()
	
	var dir = move_target - global_position
	if dir.length() > 1:
		global_position += dir.normalized() * move_speed * delta
	else:
		choose_new_target()

func choose_new_target():
	var offset = Vector2(randf_range(-100,100), randf_range(-80,80))
	var target = global_position + offset
	
	target.x = clamp(target.x, 50, arena_width - 50)
	target.y = clamp(target.y, 50, arena_height - 50)
	
	if target.distance_to(player.global_position) < 80:
		target += (target - player.global_position).normalized() * 50
	
	move_target = target

func shoot_attack_pattern():
	match pattern_type:
		0:
			shoot_aimed()
		1:
			shoot_radial(8)
		2:
			shoot_curved(5, 0.2)

func shoot_aimed():
	var bullet = bullet_scene.instantiate()
	bullet.global_position = global_position + (player.global_position - global_position).normalized() * 40
	bullet.direction = (player.global_position - global_position).normalized()
	get_parent().add_child(bullet)

func shoot_radial(count):
	for i in range(count):
		var angle = (2 * PI / count) * i
		var bullet = bullet_scene.instantiate()
		bullet.global_position = global_position + Vector2(cos(angle), sin(angle)) * 40
		bullet.direction = Vector2(cos(angle), sin(angle)).normalized()
		get_parent().add_child(bullet)

func shoot_curved(count, angle_offset):
	for i in range(count):
		var bullet = bullet_scene.instantiate()
		bullet.global_position = global_position + Vector2(cos(i), sin(i)) * 40
		var angle = (player.global_position - global_position).angle() + deg_to_rad(-15 + i * 7.5)
		bullet.direction = Vector2(cos(angle), sin(angle)).normalized()
		get_parent().add_child(bullet)

func spawn_ally_bullets():
	for i in range(ally_bullet_count):
		var bullet = ally_bullet_scene.instantiate()
		bullet.global_position = player.global_position + Vector2(randf_range(-60,60), randf_range(-30,30))
		bullet.picked_up = false
		get_parent().add_child(bullet)
		ally_bullets.append(bullet)

func _on_area_entered(area: Area2D) -> void:
	Global.bossHealth -= 1
	shadersMat.set_shader_parameter("speed", 0.8)
	await get_tree().create_timer(0.3).timeout
	shadersMat.set_shader_parameter("speed", 0.0)
