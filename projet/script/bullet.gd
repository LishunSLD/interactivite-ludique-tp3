extends Area2D

@export var speed: float = 200
@export var lifetime: float = 5.0

var direction: Vector2 = Vector2.ZERO
var life_timer: float = 0.0

func _process(delta):
	global_position += direction * speed * delta
	life_timer += delta
	if life_timer >= lifetime:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Cercey":
		Global.health -= 1
		var shadersMat: ShaderMaterial = body.get_node("AnimatedSprite2D").material
		shadersMat.set_shader_parameter("speed", 0.8)
		await get_tree().create_timer(0.3).timeout
		shadersMat.set_shader_parameter("speed", 0.0)
		queue_free()
