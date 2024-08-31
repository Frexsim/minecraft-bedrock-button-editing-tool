extends Node
class_name AssetManager

signal asset_imported(imported_type: AssetType, asset_info: Dictionary)

@export_group("Interface Components")
@export var import_file_dialog: FileDialog

@export_group("Editor Components")
@export var button_preview: Node2D

enum ImporterState {
	READY,
	SELECTING_SPRITE_SHEET,
	IMPORTING
}
enum AssetType { BACKGROUND, LEFT_ANIM, RIGHT_ANIM }

var state = ImporterState.READY
var import_type = null

var imported_assets = {
	"backgrounds": [],
	"left_anims": [],
	"right_anims": [],
}



func select_file_for_import(type: AssetType):
	if state == ImporterState.READY:
		state = ImporterState.SELECTING_SPRITE_SHEET
		import_type = type
		import_file_dialog.show()

func reset_import():
	state = ImporterState.READY
	import_type = null
	
	print("Reset import, ready for next import!")

func _on_import_cancelled():
	reset_import()

func _on_files_selected(paths: PackedStringArray):
	state = ImporterState.IMPORTING
	
	print("Importing " + str(paths.size()) + " file(s)...")
	
	for path in paths:
		var sprite_sheet_json_file_path = path
		
		print("Importing \"" + sprite_sheet_json_file_path.get_basename() + "\"...")
		
		var sprite_sheet_basename = path.get_file().get_basename()
		var sprite_sheet_image_file_path = path.get_base_dir() + "/" + sprite_sheet_basename + ".png"
		if FileAccess.file_exists(sprite_sheet_image_file_path):
			if import_type == AssetType.BACKGROUND:
				import_background(sprite_sheet_json_file_path, sprite_sheet_image_file_path)
			elif import_type == AssetType.LEFT_ANIM:
				import_left_anim(sprite_sheet_json_file_path, sprite_sheet_image_file_path)
			elif import_type == AssetType.RIGHT_ANIM:
				import_right_anim(sprite_sheet_json_file_path, sprite_sheet_image_file_path)
			else:
				print("Failed to import, import type was null.")
		else:
			print("Failed to import, could not find matching image file.")
	
	reset_import()

func import_background(sprite_sheet_json_path: String, sprite_image_path: String):
	print("Importing as background...")
	
	var imported_background = Importer.import_aseprite_sprite_sheet(sprite_sheet_json_path, sprite_image_path)
	var asset_info = {
		"filename": sprite_image_path.get_file().get_basename(),
		"asset": imported_background,
	}
	imported_assets.backgrounds.push_front(asset_info)
	asset_imported.emit(AssetType.BACKGROUND, asset_info)
	
	button_preview.set_background(button_preview.StateType.DEFAULT, asset_info)
	
	print("Importing finished!")

func import_left_anim(sprite_sheet_json_path: String, sprite_image_path: String):
	print("Importing as left animation...")
	
	var imported_left_anim = Importer.import_aseprite_sprite_sheet(sprite_sheet_json_path, sprite_image_path)
	var asset_info = {
		"filename": sprite_image_path.get_file().get_basename(),
		"asset": imported_left_anim,
	}
	imported_assets.left_anims.push_front(asset_info)
	asset_imported.emit(AssetType.LEFT_ANIM, asset_info)
	
	button_preview.set_left_anim(button_preview.StateType.DEFAULT, asset_info)
	
	print("Importing finished!")

func import_right_anim(sprite_sheet_json_path: String, sprite_image_path: String):
	print("Importing as right animation...")
	
	var imported_right_anim = Importer.import_aseprite_sprite_sheet(sprite_sheet_json_path, sprite_image_path)
	var asset_info = {
		"filename": sprite_image_path.get_file().get_basename(),
		"asset": imported_right_anim,
	}
	imported_assets.right_anims.push_front(asset_info)
	asset_imported.emit(AssetType.RIGHT_ANIM, asset_info)
	
	button_preview.set_right_anim(button_preview.StateType.DEFAULT, asset_info)
	
	print("Importing finished!")
