class_name BaseBuff
extends Panel

@export var buff_type:String
@export var continue_time:float = 5.0

signal buff_over(buff_type:String)

func _ready() -> void:
	var tween:Tween = create_tween()
	tween.tween_property(self, "modulate:a", 0, continue_time)
	tween.finished.connect(Callable(self, "_on_tween_finished"))

func _on_tween_finished() -> void:
	_over()

func _over() -> void:
	emit_signal("buff_over", buff_type)
