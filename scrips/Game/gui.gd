extends CanvasLayer

@export var P1_HPBAR:TextureProgressBar
@export var P1_EPBAR:TextureProgressBar
@export var P2_HPBAR:TextureProgressBar
@export var P2_EPBAR:TextureProgressBar
@export var Title: Label
@export var Years: Label
@export var sorce: Label
@export var TrashContainer: Node2D

@export var game_over_scene: PackedScene
@export var bg_music2:AudioStream


@onready var container: Control = $Container


func _ready() -> void:
	CountInstance.sorce = 0
	TrashContainer.connect("trash_body_entered", Callable(self, "update_title"))

func update_title(body:BaseTrash):
	if body.trash_id.to_lower() == "plastic":
		Title.text = "塑料瓶"
		Years.text = "100年 - 500年"
	elif body.trash_id.to_lower() == "glass":
		Title.text = "玻璃瓶"
		Years.text = "4000年 - 100w年"
	elif body.trash_id.to_lower() == "paper":
		Title.text = "纸"
		Years.text = "1年 - 10年"
	elif body.trash_id.to_lower() == "metal":
		Title.text = "罐头"
		Years.text = "50年 - 100年"
	elif body.trash_id.to_lower() == "drink_can":
		Title.text = "易拉罐"
		Years.text = "80年 - 200年"
	elif body.trash_id.to_lower() == "food":
		Title.text = "厨余垃圾"
		Years.text = "1月 - 3月"
	elif body.trash_id.to_lower() == "battery":
		Title.text = "电池"
		Years.text = "50年 - 100年"
	CountInstance.sorce += 1
	sorce.text = str(CountInstance.sorce)
	if CountInstance.sorce == 20:
		var game_over_instance = game_over_scene.instantiate()
		game_over_instance.peace_end()
		container.add_child(game_over_instance)
		AudioManager.play_music(bg_music2)

func set_player_hp(hp, player_id):
	if player_id == 1:
		P1_HPBAR.value = hp
	elif player_id == 2:
		P2_HPBAR.value = hp

func set_player_ep(ep, player_id):
	if player_id == 1:
		P1_EPBAR.value = ep
	elif player_id == 2:
		P2_EPBAR.value = ep
