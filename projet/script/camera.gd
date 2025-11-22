extends Camera2D

@onready var dialogBox: Sprite2D = $TextBox
@onready var dialogName: RichTextLabel = $Name
@onready var dialogText: RichTextLabel = $Text
@onready var tween: Tween = create_tween()
@onready var vignetteIn: ColorRect = $VignetteZoomedIn
@onready var vignetteOut: ColorRect = $VignetteZoomedOut
@onready var shaders: ColorRect = $Shaders
@onready var shadersMat: ShaderMaterial = $Shaders.material

@onready var sfxDialogue: AudioStreamPlayer2D = $Dialogue
@onready var clefDisplay: RichTextLabel = $Clefs

var _is_showing := false
var _queue: Array = []

@onready var parent: Node2D = $"../../"

func _ready() -> void:
	vignetteIn.show()
	vignetteOut.show()
	shaders.show()
	dialogBox.visible = false
	dialogName.visible = false
	dialogText.visible = false

	dialogBox.modulate.a = 0.0
	dialogName.modulate.a = 0.0
	dialogText.modulate.a = 0.0

func _process(delta: float) -> void:
	var keys = Global.keys
	clefDisplay.text = str(keys)

func dialog(name_text: String, message: String, duration: float = 3.0, postfx: bool = false, end: bool = false) -> void:
	_queue.append({
		"name": name_text,
		"message": message,
		"duration": duration,
		"postfx": postfx
	})

	if not _is_showing:
		next_dialog()


func next_dialog() -> void:
	if _queue.is_empty():
		_is_showing = false
		return
	
	_is_showing = true
	var next = _queue.pop_front()
	await display_dialog(next["name"], next["message"], next["duration"], next["postfx"])
	next_dialog()


func display_dialog(name_text: String, message: String, duration: float, postfx: bool) -> void:
	#zoom = Vector2(3, 3)
	#vignetteIn.hide()
	dialogName.text = name_text
	dialogText.text = message
	dialogBox.visible = true
	dialogName.visible = true
	dialogText.visible = true
	#clefDisplay.text = str(keys)
	
	if postfx == true:
		shadersMat.set_shader_parameter("enable_posterize", true)
		shadersMat.set_shader_parameter("exposure", 1.16)
	
	sfxDialogue.play()

	var fade_in = create_tween()
	fade_in.tween_property(dialogBox, "modulate:a", 1.0, 0.5)
	fade_in.parallel().tween_property(dialogName, "modulate:a", 1.0, 0.5)
	fade_in.parallel().tween_property(dialogText, "modulate:a", 1.0, 0.5)
	await fade_in.finished

	await get_tree().create_timer(duration).timeout

	var fade_out = create_tween()
	fade_out.tween_property(dialogBox, "modulate:a", 0.0, 0.5)
	fade_out.parallel().tween_property(dialogName, "modulate:a", 0.0, 0.5)
	fade_out.parallel().tween_property(dialogText, "modulate:a", 0.0, 0.5)
	await fade_out.finished

	shadersMat.set_shader_parameter("enable_posterize", false)
	shadersMat.set_shader_parameter("exposure", 0.45)
	dialogBox.visible = false
	dialogName.visible = false
	dialogText.visible = false
	#zoom = Vector2(5, 5)
	#vignetteIn.show()s
