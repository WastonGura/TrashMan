class_name BUFFContainer
extends HBoxContainer

var buff_type_pool:Array = []

@export var max_size:int = 4
@export var player:Player


## TODO buff实例需要做到
func add_new_buff(new_buff:BaseBuff) -> void:
	if new_buff.buff_type in buff_type_pool:
		var old_buff:BaseBuff = get_buff(new_buff.buff_type)
		_buff_over(old_buff.buff_type)
		old_buff.queue_free()
		buff_type_pool.erase(old_buff.buff_type)
	if buff_type_pool.size() >= max_size:
		var old_buff:BaseBuff = get_buff(buff_type_pool[0])
		_buff_over(old_buff.buff_type)
		old_buff.queue_free()
		buff_type_pool.pop_front()
	new_buff.buff_over.connect(Callable(self,"_buff_over"))
	add_child(new_buff)
	buff_type_pool.append(new_buff.buff_type)
	_handle_buff_effect(new_buff.buff_type)

func _handle_buff_effect(buff_type:String) -> void:
	player.buff_component.add_buff_to_pool(buff_type)

func _buff_over(buff_type:String) -> void:
	var buff = get_buff(buff_type)
	if buff == null:
		return
	player.buff_component.remove_buff_from_pool(buff_type)
	buff.queue_free()
	buff_type_pool.erase(buff.buff_type)
	print("清除完畢")

func get_buff(buff_type:String) -> BaseBuff:
	for b in get_children():
		if b.buff_type == buff_type:
			return b
	printerr("没有这个类型的BUFF节点")
	return
