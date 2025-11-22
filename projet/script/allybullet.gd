extends Area2D

@export var speed: float = 250
@export var lifetime: float = 5.0
@onready var sfxShoot: AudioStreamPlayer2D = $Shoot

var picked_up: bool = false
var target: Node2D
var life_timer: float = 0.0

func _ready():
	picked_up = false

func _process(delta):
	if picked_up and target and target.is_inside_tree():
		var dir = (target.global_position - global_position).normalized()
		global_position += dir * speed * delta

	life_timer += delta
	if life_timer >= lifetime:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Cercey" and not picked_up:
		picked_up = true
		target = get_parent().get_node("Lusin")
		sfxShoot.play()
	elif body.name == "Lusin":
		Global.bossHealth -= 1
		var shadersMat: ShaderMaterial = body.get_node("Sprite2D").material
		shadersMat.set_shader_parameter("speed", 0.8)
		await get_tree().create_timer(0.3).timeout
		shadersMat.set_shader_parameter("speed", 0.0)
		queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area.name == "Lusin":
		Global.bossHealth -= 1
		var shadersMat: ShaderMaterial = area.get_node("Sprite2D").material
		shadersMat.set_shader_parameter("speed", 0.8)
		await get_tree().create_timer(0.3).timeout
		shadersMat.set_shader_parameter("speed", 0.0)
		queue_free()

func _on_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if area.name == "Lusin":
		Global.bossHealth -= 1
		var shadersMat: ShaderMaterial = area.get_node("Sprite2D").material
		shadersMat.set_shader_parameter("speed", 0.8)
		await get_tree().create_timer(0.3).timeout
		shadersMat.set_shader_parameter("speed", 0.0)
		queue_free()


func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.name == "Lusin":
		Global.bossHealth -= 1
		var shadersMat: ShaderMaterial = body.get_node("Sprite2D").material
		shadersMat.set_shader_parameter("speed", 0.8)
		await get_tree().create_timer(0.3).timeout
		shadersMat.set_shader_parameter("speed", 0.0)
		queue_free()
