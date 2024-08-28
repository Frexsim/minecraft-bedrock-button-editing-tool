extends Node


func import_aseprite_sprite_sheet(json_path: String, image_path: String) -> SpriteFrames:
	var json_file = FileAccess.open(json_path, FileAccess.READ)
	var json_file_data = JSON.parse_string(json_file.get_as_text())
	
	var image = Image.load_from_file(image_path)
	
	var sprite_frames = SpriteFrames.new()
	if json_file_data.has("frames"):
		for frame_data in json_file_data.frames:
			print(frame_data)
			
			var frame_image = image.get_region(Rect2i(frame_data.frame.x, frame_data.frame.y, frame_data.frame.w, frame_data.frame.h))
			var frame_image_texture = ImageTexture.create_from_image(frame_image)
			
			sprite_frames.add_frame("default", frame_image_texture, frame_data.duration / 100)
	else:
		sprite_frames.add_frame("default", ImageTexture.create_from_image(image))
		
	json_file.close()
	
	return sprite_frames
