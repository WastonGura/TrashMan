extends Node


func choose_type(player_id:String) -> String:
	if player_id == '1':
		return "recycle"
	elif player_id == '2':
		return "harm"
	else:
		return "normal"
