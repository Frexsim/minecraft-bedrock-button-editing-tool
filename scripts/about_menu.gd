extends PanelContainer


func _ready():
	hide()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("about_toggle"):
		visible = not visible
