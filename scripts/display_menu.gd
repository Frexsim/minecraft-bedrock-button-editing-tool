extends PanelContainer

@export_group("Managers")
@export var button_preview_manager: ButtonPreviewManager
@export_group("Interface Components")
@export var main_state_option: OptionButton
@export var interactable_main_state_option_warning: TextureRect
@export var preview_type_option: OptionButton
@export_subgroup("Position Properties")
@export var default_left_anim_position_property: Vector2SpinBoxGroup
@export var hover_left_anim_position_property: Vector2SpinBoxGroup
@export var default_right_anim_position_property: Vector2SpinBoxGroup
@export var hover_right_anim_position_property: Vector2SpinBoxGroup



func _ready() -> void:
	update_selected_main_state(main_state_option.selected)
	
	button_preview_manager.state_changed.connect(func(new_state: ButtonPreviewManager.StateType):
		if new_state == ButtonPreviewManager.StateType.DEFAULT:
			main_state_option.select(0)
		elif new_state == ButtonPreviewManager.StateType.HOVER:
			main_state_option.select(1)
		elif new_state == ButtonPreviewManager.StateType.PRESSED:
			main_state_option.select(2)
	)
	button_preview_manager.anim_position_changed.connect(func(side: ButtonPreviewManager.AnimSide, state: ButtonPreviewManager.AssetStateType, new_position: Vector2):
		if side == ButtonPreviewManager.AnimSide.LEFT:
			if state == ButtonPreviewManager.AssetStateType.DEFAULT:
				default_left_anim_position_property.set_value_quietly(new_position)
			elif state == ButtonPreviewManager.AssetStateType.HOVER:
				hover_left_anim_position_property.set_value_quietly(new_position)
		elif side == ButtonPreviewManager.AnimSide.RIGHT:
			if state == ButtonPreviewManager.AssetStateType.DEFAULT:
				default_right_anim_position_property.set_value_quietly(new_position)
			elif state == ButtonPreviewManager.AssetStateType.HOVER:
				hover_right_anim_position_property.set_value_quietly(new_position)
	)

func _on_main_state_changed(index: int):
	update_selected_main_state(index)

func _on_interactable_main_state_changed(is_enabled: bool):
	button_preview_manager.set_interactable_mode(is_enabled)
	interactable_main_state_option_warning.visible = is_enabled
	main_state_option.disabled = is_enabled

func update_selected_main_state(index: int):
	var option_button_item_text = main_state_option.get_item_text(index)
	
	if option_button_item_text == "Default":
		button_preview_manager.set_preview_state(ButtonPreviewManager.StateType.DEFAULT)
	elif option_button_item_text == "Hover":
		button_preview_manager.set_preview_state(ButtonPreviewManager.StateType.HOVER)
	elif option_button_item_text == "Pressed":
		button_preview_manager.set_preview_state(ButtonPreviewManager.StateType.PRESSED)

func _on_preview_type_changed(index: int):
	var option_button_item_text = preview_type_option.get_item_text(index)
	
	if option_button_item_text == "Default":
		button_preview_manager.set_preview_type(ButtonPreviewManager.PreviewType.DEFAULT)
	elif option_button_item_text == "Education":
		button_preview_manager.set_preview_type(ButtonPreviewManager.PreviewType.EDUCATION)

func _on_default_left_anim_pos_changed(value: Vector2):
	button_preview_manager.set_anim_position(ButtonPreviewManager.AnimSide.LEFT, ButtonPreviewManager.AssetStateType.DEFAULT, value)

func _on_hover_left_anim_pos_changed(value: Vector2):
	button_preview_manager.set_anim_position(ButtonPreviewManager.AnimSide.LEFT, ButtonPreviewManager.AssetStateType.HOVER, value)

func _on_default_right_anim_pos_changed(value: Vector2):
	button_preview_manager.set_anim_position(ButtonPreviewManager.AnimSide.RIGHT, ButtonPreviewManager.AssetStateType.DEFAULT, value)

func _on_hover_right_anim_pos_changed(value: Vector2):
	button_preview_manager.set_anim_position(ButtonPreviewManager.AnimSide.RIGHT, ButtonPreviewManager.AssetStateType.HOVER, value)
