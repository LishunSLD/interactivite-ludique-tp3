extends Camera2D

@onready var clefDisplay: RichTextLabel = $Clefs

func _process(delta: float) -> void:
	clefDisplay.text = str(Global.health)
