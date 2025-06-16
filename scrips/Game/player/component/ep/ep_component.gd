class_name EPComponent extends Node2D

@export var EP = 20
@export var max_EP = 100
@export var min_EP = 0

func get_EP() -> float:
	return EP

func set_EP(new_EP) -> void:
	EP = min(new_EP, max_EP)

func update_ep(value:float, duration:float) -> void:
	var old_ep:float = get_EP()
	var new_ep:float = old_ep + value
	new_ep = clampf(new_ep, min_EP, max_EP)
	if duration <= 0:
		set_EP(new_ep)
		return
	var tween:Tween = create_tween()
	tween.tween_property(self, "EP", new_ep, duration)

func update_ep_by_trash() -> void:
	var currernt_ep = get_EP()
	var new_ep = currernt_ep + 40
	set_EP(new_ep)

func consume_EP(amount) -> void:
	var new_EP = get_EP() - amount
	new_EP = max(new_EP, 0)
	set_EP(new_EP)
