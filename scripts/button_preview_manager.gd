extends Node
class_name ButtonPreviewManager

signal asset_changed(state: StateType, type: AssetManager.AssetType, asset_info: Dictionary)

@export_group("Button Components")
@export_subgroup("Default")
@export var default_background: AnimatedSprite2D
@export var default_left_anim: AnimatedSprite2D
@export var default_right_anim: AnimatedSprite2D
@export_subgroup("Hover")
@export var hover_background: AnimatedSprite2D
@export var hover_left_anim: AnimatedSprite2D
@export var hover_right_anim: AnimatedSprite2D

enum StateType { DEFAULT, HOVER, PRESSED }



func restart_anims():
	if default_background.sprite_frames != null: default_background.stop(); default_background.play("default")
	if default_left_anim.sprite_frames != null: default_left_anim.stop(); default_left_anim.play("default")
	if default_right_anim.sprite_frames != null: default_right_anim.stop(); default_right_anim.play("default")
	if hover_background.sprite_frames != null: hover_background.stop(); hover_background.play("default")
	if hover_left_anim.sprite_frames != null: hover_left_anim.stop(); hover_left_anim.play("default")
	if hover_right_anim.sprite_frames != null: hover_right_anim.stop(); hover_right_anim.play("default")

func set_background(state: StateType, asset_info: Dictionary):
	if state == StateType.DEFAULT:
		default_background.sprite_frames = asset_info.asset
	elif state == StateType.HOVER or state == StateType.PRESSED:
		hover_background.sprite_frames = asset_info.asset
	
	asset_changed.emit(state, AssetManager.AssetType.BACKGROUND, asset_info)
	
	restart_anims()

func set_left_anim(state: StateType, asset_info: Dictionary):
	if state == StateType.DEFAULT:
		default_left_anim.sprite_frames = asset_info.asset
	elif state == StateType.HOVER or state == StateType.PRESSED:
		hover_left_anim.sprite_frames = asset_info.asset
	
	asset_changed.emit(state, AssetManager.AssetType.LEFT_ANIM, asset_info)
	
	restart_anims()

func set_right_anim(state: StateType, asset_info: Dictionary):
	if state == StateType.DEFAULT:
		default_right_anim.sprite_frames = asset_info.asset
	elif state == StateType.HOVER or state == StateType.PRESSED:
		hover_right_anim.sprite_frames = asset_info.asset
	
	asset_changed.emit(state, AssetManager.AssetType.RIGHT_ANIM, asset_info)
	
	restart_anims()
