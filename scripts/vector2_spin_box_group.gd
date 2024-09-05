extends HBoxContainer
class_name Vector2SpinBoxGroup

signal value_changed(new_value: Vector2)

@export var x_spin_box: SpinBox
@export var y_spin_box: SpinBox

var value = Vector2()



func _ready() -> void:
	x_spin_box.value_changed.connect(func(axis_value: float):
		var new_value = value
		new_value.x = axis_value
		set_value(new_value)
	)
	y_spin_box.value_changed.connect(func(axis_value: float):
		var new_value = value
		new_value.y = axis_value
		set_value(new_value)
	)

func set_value(new_value: Vector2):
	value = new_value
	
	x_spin_box.value = value.x
	y_spin_box.value = value.y
	
	value_changed.emit(value)

func set_value_quietly(new_value: Vector2):
	value = new_value
	
	x_spin_box.value = value.x
	y_spin_box.value = value.y
