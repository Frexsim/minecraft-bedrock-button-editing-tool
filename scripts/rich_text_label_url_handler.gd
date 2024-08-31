extends RichTextLabel


func _ready():
	meta_clicked.connect(func(meta: Variant):
		OS.shell_open(str(meta))
	)
