extends Node

signal asset_imported(imported_type: ImportingType, asset_info: Dictionary)

@export_group("Interface Components")
@export var json_file_dialog: FileDialog
@export var image_file_dialog: FileDialog

@export_group("Editor Components")
@export var button_preview: Node2D

enum ImporterState {
	READY,
	SELECTING_SPRITE_SHEET_JSON,
	SELECTING_SPRITE_SHEET_IMAGE,
	IMPORTING
}
enum ImportingType { BACKGROUND, LEFT_ANIM, RIGHT_ANIM }

var state = ImporterState.READY
var import_type = null
var current_sprite_sheet_json_file_path = null
var current_sprite_sheet_image_file_path = null

var imported_assets = {
	"backgrounds": [],
	"left_anims": [],
	"right_anims": [],
}

func _on_import_background_pressed():
	select_file_for_import(ImportingType.BACKGROUND)

func _on_import_left_anim_pressed():
	select_file_for_import(ImportingType.LEFT_ANIM)

func _on_import_right_anim_pressed():
	select_file_for_import(ImportingType.RIGHT_ANIM)

func select_file_for_import(type: ImportingType):
	if state == ImporterState.READY:
		state = ImporterState.SELECTING_SPRITE_SHEET_JSON
		import_type = type
		json_file_dialog.show()

func import_cancelled():
	state = ImporterState.READY

func _on_file_selected(path: String):
	print(path)
	
	if state == ImporterState.SELECTING_SPRITE_SHEET_JSON:
		state = ImporterState.SELECTING_SPRITE_SHEET_IMAGE
		
		current_sprite_sheet_json_file_path = path
		image_file_dialog.show()
	elif state == ImporterState.SELECTING_SPRITE_SHEET_IMAGE:
		current_sprite_sheet_image_file_path = path
		
		if import_type == ImportingType.BACKGROUND:
			import_background(current_sprite_sheet_json_file_path, current_sprite_sheet_image_file_path)
		elif import_type == ImportingType.LEFT_ANIM:
			import_left_anim(current_sprite_sheet_json_file_path, current_sprite_sheet_image_file_path)
		elif import_type == ImportingType.RIGHT_ANIM:
			import_right_anim(current_sprite_sheet_json_file_path, current_sprite_sheet_image_file_path)

func import_background(sprite_sheet_json_path: String, sprite_image_path: String):
	state = ImporterState.IMPORTING
	
	var imported_background = Importer.import_aseprite_sprite_sheet(sprite_sheet_json_path, sprite_image_path)
	
	var split_sprite_image_path = sprite_image_path.split("/")
	var sprite_image_filename = split_sprite_image_path[split_sprite_image_path.size() - 1]
	var asset_info = {
		"filename": sprite_image_filename,
		"asset": imported_background,
	}
	imported_assets.backgrounds.push_front(asset_info)
	asset_imported.emit(ImportingType.BACKGROUND, asset_info)
	
	button_preview.set_background(button_preview.StateType.DEFAULT, imported_background)
	
	import_type = null
	state = ImporterState.READY

func import_left_anim(sprite_sheet_json_path: String, sprite_image_path: String):
	state = ImporterState.IMPORTING
	
	var imported_left_anim = Importer.import_aseprite_sprite_sheet(sprite_sheet_json_path, sprite_image_path)
	
	var split_sprite_image_path = sprite_image_path.split("/")
	var sprite_image_filename = split_sprite_image_path[split_sprite_image_path.size() - 1]
	var asset_info = {
		"filename": sprite_image_filename,
		"asset": imported_left_anim,
	}
	imported_assets.left_anims.push_front(asset_info)
	asset_imported.emit(ImportingType.LEFT_ANIM, asset_info)
	
	button_preview.set_left_anim(button_preview.StateType.DEFAULT, imported_left_anim)
	
	import_type = null
	state = ImporterState.READY

func import_right_anim(sprite_sheet_json_path: String, sprite_image_path: String):
	state = ImporterState.IMPORTING
	
	var imported_right_anim = Importer.import_aseprite_sprite_sheet(sprite_sheet_json_path, sprite_image_path)
	
	var split_sprite_image_path = sprite_image_path.split("/")
	var sprite_image_filename = split_sprite_image_path[split_sprite_image_path.size() - 1]
	var asset_info = {
		"filename": sprite_image_filename,
		"asset": imported_right_anim,
	}
	imported_assets.right_anims.push_front(asset_info)
	asset_imported.emit(ImportingType.RIGHT_ANIM, asset_info)
	
	button_preview.set_right_anim(button_preview.StateType.DEFAULT, imported_right_anim)
	
	import_type = null
	state = ImporterState.READY
