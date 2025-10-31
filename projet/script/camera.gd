extends Camera2D

@onready var dialogBox: Sprite2D = $TextBox
@onready var dialogName: RichTextLabel = $Name
@onready var dialogText: RichTextLabel = $Text
@onready var tween: Tween = create_tween()
@onready var vignetteIn: ColorRect = $VignetteZoomedIn
@onready var vignetteOut: ColorRect = $VignetteZoomedOut
@onready var shaders: ColorRect = $Shaders

@onready var sfxDialogue: AudioStreamPlayer2D = $Dialogue

var _is_showing := false
var _queue: Array = []


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
	
	dialog("[b]Cercey[/b]", "Quel genre de passage caché est-ce ?", 3)
	dialog("[b]Cercey[/b]", "Maintenant, à la recherche du Comte.", 3)
	dialog("[b]Cercey[/b]", "Où est-il?", 2)


func dialog(name_text: String, message: String, duration: float = 3.0) -> void:
	_queue.append({
		"name": name_text,
		"message": message,
		"duration": duration
	})

	if not _is_showing:
		next_dialog()


func next_dialog() -> void:
	if _queue.is_empty():
		_is_showing = false
		return
	
	_is_showing = true
	var next = _queue.pop_front()
	await display_dialog(next["name"], next["message"], next["duration"])
	next_dialog()


func display_dialog(name_text: String, message: String, duration: float) -> void:
	#zoom = Vector2(3, 3)
	#vignetteIn.hide()
	dialogName.text = name_text
	dialogText.text = message
	dialogBox.visible = true
	dialogName.visible = true
	dialogText.visible = true
	
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

	dialogBox.visible = false
	dialogName.visible = false
	dialogText.visible = false
	#zoom = Vector2(5, 5)
	#vignetteIn.show()s
