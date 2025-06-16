class_name BuffComponent
extends Node2D


var buff_pool:Array[String] = []

@export var player_control:PlayerControl
@export var player:Player



func _open_attack_advance_buff() -> void:
	var old_atk = player.attack_component.get_ATK()
	var new_atk = old_atk + 15
	player.attack_component.set_ATK(new_atk)

func _open_health_buff() -> void:
	player.healeth_component.health_player(50, 5.0)

func _open_energy_buff() -> void:
	player.ep_component.update_ep(30, 5.0)

func _open_speed_buff() -> void:
	player_control.RUNSPEED += 300

func _close_attack_advance_buff() -> void:
	var old_atk = player.attack_component.get_ATK()
	var new_atk = old_atk - 15
	player.attack_component.set_ATK(new_atk)

func _close_health_buff() -> void:
	pass

func _close_energy_buff() -> void:
	pass

func _close_speed_buff() -> void:
	player_control.RUNSPEED -= 300

func add_buff_to_pool(new_buff:String) -> void:
	buff_pool.append(new_buff)
	_open_buff(new_buff)

func remove_buff_from_pool(buff_type:String) -> void:
	if buff_type in buff_pool:
		buff_pool.erase(buff_type)
		_close_buff(buff_type)

func _open_buff(buff_type:String) -> void:
	match buff_type:
		"attack_advance_buff":
			_open_attack_advance_buff()
		"health_buff":
			_open_health_buff()
		"energy_buff":
			_open_energy_buff()
		"speed_buff":
			_open_speed_buff()

func _close_buff(buff_type:String) -> void:
	match buff_type:
		"attack_advance_buff":
			_close_attack_advance_buff()
		"health_buff":
			_close_health_buff()
		"energy_buff":
			_close_energy_buff()
		"speed_buff":
			_close_speed_buff()
