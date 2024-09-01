extends PanelContainer

@export_group("Managers")
@export var button_preview_manager: ButtonPreviewManager
@export_group("Interface Components")
@export var main_state_option: OptionButton
@export var preview_type_option: OptionButton



func _ready() -> void:
	update_selected_main_state(main_state_option.selected)

func _on_main_state_changed(index: int):
	update_selected_main_state(index)

func update_selected_main_state(index: int):
	var option_button_item_text = main_state_option.get_item_text(index)
	
	button_preview_manager.set_interactable_mode(false)
	
	if option_button_item_text == "Default":
		button_preview_manager.set_preview_state(ButtonPreviewManager.StateType.DEFAULT)
	elif option_button_item_text == "Hover":
		button_preview_manager.set_preview_state(ButtonPreviewManager.StateType.HOVER)
	elif option_button_item_text == "Pressed":
		button_preview_manager.set_preview_state(ButtonPreviewManager.StateType.PRESSED)
	elif option_button_item_text == "Auto/Interactable":
		button_preview_manager.set_interactable_mode(true)

func _on_preview_type_changed(index: int):
	var option_button_item_text = preview_type_option.get_item_text(index)
	
	if option_button_item_text == "Default":
		button_preview_manager.set_preview_type(ButtonPreviewManager.PreviewType.DEFAULT)
	elif option_button_item_text == "Education":
		button_preview_manager.set_preview_type(ButtonPreviewManager.PreviewType.EDUCATION)
