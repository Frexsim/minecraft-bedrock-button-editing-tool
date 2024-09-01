extends PanelContainer

@export_group("Managers")
@export var button_preview_manager: ButtonPreviewManager
@export_group("Interface Components")
@export var default_text_color_picker_button: ColorPickerButton
@export var default_border_color_picker_button: ColorPickerButton
@export var hover_text_color_picker_button: ColorPickerButton
@export var hover_border_color_picker_button: ColorPickerButton
@export var pressed_text_color_picker_button: ColorPickerButton
@export var pressed_border_color_picker_button: ColorPickerButton



func _ready() -> void:
	button_preview_manager.set_text_color(ButtonPreviewManager.StateType.DEFAULT, default_text_color_picker_button.color)
	button_preview_manager.set_border_color(ButtonPreviewManager.StateType.DEFAULT, default_border_color_picker_button.color)
	button_preview_manager.set_text_color(ButtonPreviewManager.StateType.HOVER, hover_text_color_picker_button.color)
	button_preview_manager.set_border_color(ButtonPreviewManager.StateType.HOVER, hover_border_color_picker_button.color)
	button_preview_manager.set_text_color(ButtonPreviewManager.StateType.PRESSED, pressed_text_color_picker_button.color)
	button_preview_manager.set_border_color(ButtonPreviewManager.StateType.PRESSED, pressed_border_color_picker_button.color)

func _on_default_text_color_changed(color: Color):
	button_preview_manager.set_text_color(ButtonPreviewManager.StateType.DEFAULT, color)

func _on_default_border_color_changed(color: Color):
	button_preview_manager.set_border_color(ButtonPreviewManager.StateType.DEFAULT, color)

func _on_hover_text_color_changed(color: Color):
	button_preview_manager.set_text_color(ButtonPreviewManager.StateType.HOVER, color)

func _on_hover_border_color_changed(color: Color):
	button_preview_manager.set_border_color(ButtonPreviewManager.StateType.HOVER, color)

func _on_pressed_text_color_changed(color: Color):
	button_preview_manager.set_text_color(ButtonPreviewManager.StateType.PRESSED, color)

func _on_pressed_border_color_changed(color: Color):
	button_preview_manager.set_border_color(ButtonPreviewManager.StateType.PRESSED, color)
