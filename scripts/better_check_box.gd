extends CheckBox
class_name BetterCheckBox

@export var on_text: String
@export var off_text: String



func _ready() -> void:
	update_text()
	
	pressed.connect(update_text)

func update_text() -> void:
	if button_pressed:
		text = on_text
	else:
		text = off_text
