extends PanelContainer

@export_group("Managers")
@export var asset_manager: AssetManager
@export var button_preview_manager: ButtonPreviewManager

@export_group("Interface Components")
@export var imported_backgrounds_grid: GridContainer
@export var imported_left_anims_grid: GridContainer
@export var imported_right_anims_grid: GridContainer
@export var no_imported_backgrounds: Label
@export var no_imported_left_anims: Label
@export var no_imported_right_anims: Label

@export var default_background_asset_label: Label
@export var default_left_anim_asset_label: Label
@export var default_right_anim_asset_label: Label
@export var hover_background_asset_label: Label
@export var hover_left_anim_asset_label: Label
@export var hover_right_anim_asset_label: Label



func _ready() -> void:
	no_imported_backgrounds.visible = asset_manager.imported_assets.backgrounds.size() <= 0
	no_imported_left_anims.visible = asset_manager.imported_assets.left_anims.size() <= 0
	no_imported_right_anims.visible = asset_manager.imported_assets.right_anims.size() <= 0

func _on_import_background_pressed():
	asset_manager.select_file_for_import(AssetManager.AssetType.BACKGROUND)

func _on_import_left_anim_pressed():
	asset_manager.select_file_for_import(AssetManager.AssetType.LEFT_ANIM)

func _on_import_right_anim_pressed():
	asset_manager.select_file_for_import(AssetManager.AssetType.RIGHT_ANIM)

func _on_asset_imported(importing_type: AssetManager.AssetType, asset_info: Dictionary):
	var asset_button = Button.new()
	asset_button.custom_minimum_size = Vector2i(110, 70)
	
	asset_button.text = asset_info.filename
	asset_button.icon = sprite_frames_to_animated_texture(asset_info.asset)
	
	asset_button.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	asset_button.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
	asset_button.vertical_icon_alignment = VERTICAL_ALIGNMENT_TOP
	asset_button.expand_icon = true
	
	if importing_type == AssetManager.AssetType.BACKGROUND:
		asset_button.pressed.connect(func():
			button_preview_manager.set_background(button_preview_manager.current_preview_state, asset_info)
		)
		
		no_imported_backgrounds.hide()
		imported_backgrounds_grid.add_child(asset_button)
	elif importing_type == AssetManager.AssetType.LEFT_ANIM:
		asset_button.pressed.connect(func():
			button_preview_manager.set_left_anim(button_preview_manager.current_preview_state, asset_info)
		)
		
		no_imported_left_anims.hide()
		imported_left_anims_grid.add_child(asset_button)
	elif importing_type == AssetManager.AssetType.RIGHT_ANIM:
		asset_button.pressed.connect(func():
			button_preview_manager.set_right_anim(button_preview_manager.current_preview_state, asset_info)
		)
		
		no_imported_right_anims.hide()
		imported_right_anims_grid.add_child(asset_button)

func sprite_frames_to_animated_texture(sprite_frames: SpriteFrames) -> AnimatedTexture:
	var animated_texture = AnimatedTexture.new()
	var frame_count = sprite_frames.get_frame_count("default")
	animated_texture.frames = frame_count
	animated_texture.speed_scale = 5
	for frame_index in frame_count:
		animated_texture.set_frame_texture(frame_index, sprite_frames.get_frame_texture("default", frame_index))
		animated_texture.set_frame_duration(frame_index, sprite_frames.get_frame_duration("default", frame_index))
	
	return animated_texture

func _on_button_preview_asset_changed(state: ButtonPreviewManager.StateType, asset_type: AssetManager.AssetType, asset_info: Dictionary):
	if state == ButtonPreviewManager.StateType.DEFAULT:
		if asset_type == AssetManager.AssetType.BACKGROUND:
			default_background_asset_label.text = asset_info.filename
		elif asset_type == AssetManager.AssetType.LEFT_ANIM:
			default_left_anim_asset_label.text = asset_info.filename
		elif asset_type == AssetManager.AssetType.RIGHT_ANIM:
			default_right_anim_asset_label.text = asset_info.filename
	elif state == ButtonPreviewManager.StateType.HOVER or state == ButtonPreviewManager.StateType.PRESSED:
		if asset_type == AssetManager.AssetType.BACKGROUND:
			hover_background_asset_label.text = asset_info.filename
		elif asset_type == AssetManager.AssetType.LEFT_ANIM:
			hover_left_anim_asset_label.text = asset_info.filename
		elif asset_type == AssetManager.AssetType.RIGHT_ANIM:
			hover_right_anim_asset_label.text = asset_info.filename
