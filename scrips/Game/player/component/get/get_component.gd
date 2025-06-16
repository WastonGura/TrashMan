class_name GetComponent
extends Node2D

var buff_pool:Array[String] = []
var container_size:int = 5


class BUFF:
	var attack_advance_buff:PackedScene = load("res://scenes/BUFF/attack_advance_buff.tscn")
	var health_buff:PackedScene = load("res://scenes/BUFF/health_buff.tscn")
	var energy_buff:PackedScene = load("res://scenes/BUFF/energy_buff.tscn")
	var speed_buff:PackedScene = load("res://scenes/BUFF/speed_buff.tscn")


func handle_get(area):
	if area.is_in_group("Trash"):
		area.queue_free()
		return true
	else:
		return false


func receive_effect(trash_id:String) -> void:
	var player:Player = find_root(self)
	var container:HBoxContainer = player.buff_container
	var all_buff:BUFF = BUFF.new()
	match trash_id:
		"plastic":
			add_buff(container, all_buff.attack_advance_buff)
		"metal":
			add_buff(container, all_buff.attack_advance_buff)
		"food":
			add_buff(container, all_buff.health_buff)
		"paper":
			add_buff(container, all_buff.speed_buff)
		"glass":
			add_buff(container, all_buff.energy_buff)
		"drink_can":
			add_buff(container, all_buff.energy_buff)
		"battery":
			add_buff(container, all_buff.energy_buff)
		"":
			printerr("没有这个类型的Buff")


## TODO 在Container节点中写一个脚本要包含add_new_buff()方法
## 方法的作用是判断BUFF是否已经存在，若存在就清除然后加一个新的在后面
## 如果不存在的话就直接加在后面
## 还需要判断数量是否超过最大上限，来判断是否添加上去
func add_buff(container:HBoxContainer, buff_scene:PackedScene) -> void:
	var new_buff = buff_scene.instantiate()
	container.add_new_buff(new_buff)


func find_root(node):
	var parent = node.get_parent()
	if parent == null:
		return node
	if parent is Player:
		return parent
	else:
		return find_root(parent)
