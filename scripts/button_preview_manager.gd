extends Node
class_name ButtonPreviewManager

signal asset_changed(state: StateType, type: AssetManager.AssetType, asset_info: Dictionary)

@export_group("Button Components")
@export_subgroup("Default")
@export var default_sprites_parent: Node2D
@export var default_background: AnimatedSprite2D
@export var default_left_anim: AnimatedSprite2D
@export var default_left_area: Area2D
@export var default_left_collider: CollisionShape2D
@export var default_right_anim: AnimatedSprite2D
@export var default_right_area: Area2D
@export var default_right_collider: CollisionShape2D
@export_subgroup("Hover")
@export var hover_sprites_parent: Node2D
@export var hover_background: AnimatedSprite2D
@export var hover_left_anim: AnimatedSprite2D
@export var hover_left_area: Area2D
@export var hover_left_collider: CollisionShape2D
@export var hover_right_anim: AnimatedSprite2D
@export var hover_right_area: Area2D
@export var hover_right_collider: CollisionShape2D
@export_subgroup("Text & Border")
@export var default_text: Sprite2D
@export var education_text: Sprite2D
@export var border: Sprite2D
@export_subgroup("Interaction")
@export var button_hitbox: Area2D
@export_group("Materials")
@export var outline_material: Material

enum StateType { DEFAULT, HOVER, PRESSED }
enum PreviewType { DEFAULT, EDUCATION }

var interactable_mode = false
var current_preview_state = StateType.DEFAULT
var preview_colors = {
	StateType.DEFAULT: {
		"text": Color(),
		"border": Color(),
	},
	StateType.HOVER: {
		"text": Color(),
		"border": Color(),
	},
	StateType.PRESSED: {
		"text": Color(),
		"border": Color(),
	},
}
var currently_hovered_anim = null
var drag_sprite_start = null
var drag_mouse_start = null



func _ready() -> void:
	button_hitbox.mouse_entered.connect(func():
		if interactable_mode == true:
			set_preview_state(StateType.HOVER)
	)
	button_hitbox.mouse_exited.connect(func():
		if interactable_mode == true:
			set_preview_state(StateType.DEFAULT)
	)
	button_hitbox.input_event.connect(func(viewport: Node, event: InputEvent, shape_index: int):
		if interactable_mode == true:
			if event.is_action_pressed("button_press"):
				set_preview_state(StateType.PRESSED)
			elif event.is_action_released("button_press"):
				set_preview_state(StateType.HOVER)
	)
	
	default_left_area.mouse_entered.connect(func():
		set_currently_hovered_anim(default_left_anim)
		update_hovered_anim()
	)
	default_left_area.mouse_exited.connect(func():
		unhover_anim(default_left_anim)
		update_hovered_anim()
	)
	
	default_right_area.mouse_entered.connect(func():
		set_currently_hovered_anim(default_right_anim)
		update_hovered_anim()
	)
	default_right_area.mouse_exited.connect(func():
		unhover_anim(default_right_anim)
		update_hovered_anim()
	)
	
	hover_left_area.mouse_entered.connect(func():
		set_currently_hovered_anim(hover_left_anim)
		update_hovered_anim()
	)
	hover_left_area.mouse_exited.connect(func():
		unhover_anim(hover_left_anim)
		update_hovered_anim()
	)
	
	hover_right_area.mouse_entered.connect(func():
		set_currently_hovered_anim(hover_right_anim)
		update_hovered_anim()
	)
	hover_right_area.mouse_exited.connect(func():
		unhover_anim(hover_right_anim)
		update_hovered_anim()
	)

func _process(delta: float) -> void:
	if drag_sprite_start != null and currently_hovered_anim != null:
		currently_hovered_anim.position = get_viewport().get_mouse_position() - drag_mouse_start + drag_sprite_start

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("drag_press"):
		if currently_hovered_anim != null:
			drag_sprite_start = currently_hovered_anim.position
			drag_mouse_start = get_viewport().get_mouse_position()
	elif event.is_action_released("drag_press"):
		drag_sprite_start = null
		drag_mouse_start = null

func set_currently_hovered_anim(anim: AnimatedSprite2D):
	if drag_sprite_start == null and anim.visible == true:
		currently_hovered_anim = anim

func unhover_anim(this_anim: AnimatedSprite2D):
	if drag_sprite_start == null:
		if currently_hovered_anim == this_anim:
			drag_sprite_start = null
			drag_mouse_start = null
			currently_hovered_anim = null

func update_hovered_anim():
	default_left_anim.material = null
	default_right_anim.material = null
	hover_left_anim.material = null
	hover_right_anim.material = null
	
	if currently_hovered_anim != null:
		currently_hovered_anim.material = outline_material

func set_preview_state(state: StateType):
	current_preview_state = state
	
	update_visible_sprites()
	update_colors()
	restart_anims()
	
	drag_sprite_start = null
	drag_mouse_start = null
	currently_hovered_anim = null
	update_hovered_anim()

func set_interactable_mode(is_enabled: bool):
	set_preview_state(StateType.DEFAULT)
	interactable_mode = is_enabled

func set_preview_type(preview_type: PreviewType):
	default_text.hide()
	education_text.hide()
	
	if preview_type == PreviewType.DEFAULT:
		default_text.show()
	elif preview_type == PreviewType.EDUCATION:
		education_text.show()

func update_visible_sprites():
	default_sprites_parent.hide()
	hover_sprites_parent.hide()
	
	if current_preview_state == StateType.DEFAULT:
		default_sprites_parent.show()
	elif current_preview_state == StateType.HOVER or current_preview_state == StateType.PRESSED:
		hover_sprites_parent.show()

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
	var max_sprite_size = get_sprite_frames_max_size(asset_info.asset)
	
	if state == StateType.DEFAULT:
		default_left_anim.sprite_frames = asset_info.asset
		default_left_collider.shape.size = max_sprite_size
	elif state == StateType.HOVER or state == StateType.PRESSED:
		hover_left_anim.sprite_frames = asset_info.asset
		hover_left_collider.shape.size = max_sprite_size
	
	asset_changed.emit(state, AssetManager.AssetType.LEFT_ANIM, asset_info)
	
	restart_anims()

func set_right_anim(state: StateType, asset_info: Dictionary):
	var max_sprite_size = get_sprite_frames_max_size(asset_info.asset)
	
	if state == StateType.DEFAULT:
		default_right_anim.sprite_frames = asset_info.asset
		default_right_collider.shape.size = max_sprite_size
	elif state == StateType.HOVER or state == StateType.PRESSED:
		hover_right_anim.sprite_frames = asset_info.asset
		hover_right_collider.shape.size = max_sprite_size
	
	asset_changed.emit(state, AssetManager.AssetType.RIGHT_ANIM, asset_info)
	
	restart_anims()

func update_colors():
	var current_text_color = preview_colors[current_preview_state].text
	default_text.self_modulate = current_text_color
	education_text.self_modulate = current_text_color
	
	border.self_modulate = preview_colors[current_preview_state].border

func set_text_color(state: StateType, color: Color):
	preview_colors[state].text = color
	
	update_colors()

func set_border_color(state: StateType, color: Color):
	preview_colors[state].border = color
	
	update_colors()

func get_sprite_frames_max_size(sprite_frames: SpriteFrames) -> Vector2i:
	var max_sprite_size = Vector2i(0, 0)
	for frame_index in sprite_frames.get_frame_count("default"):
		var frame_texture = sprite_frames.get_frame_texture("default", frame_index)
		var frame_texture_size = frame_texture.get_size()
		if frame_texture_size.x > max_sprite_size.x: max_sprite_size.x = frame_texture_size.x
		if frame_texture_size.y > max_sprite_size.y: max_sprite_size.y = frame_texture_size.y
	
	return max_sprite_size
