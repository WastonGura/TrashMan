extends Area2D
class_name BaseTrash

signal player_entered(body)

@export var trash_id:String = "trash"
@export var life_timer:float = 0
@export var trash_type:String = ""


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Getbox"):
		var player:Player = find_root(area)
		emit_signal("player_entered", self)
		if not check_type(player):
			var player_HP:int = player.healeth_component.get_HP()
			var new_HP:int = player_HP - 20
			player.healeth_component.set_HP(new_HP)
			player.healeth_component.show_damage_number(20,player.global_position)
			print("player_position: ", player.global_position)
		else:
			_effect(player)


func _effect(player:Player) -> void:
	player.get_component.receive_effect(trash_id)

func check_type(player:Player) -> bool:
	if player.player_type == trash_type:
		return true
	else:
		return false

func find_root(node):
	var parent = node.get_parent()
	if parent == null:
		return node
	if parent is Player:
		return parent
	else:
		return find_root(parent)
