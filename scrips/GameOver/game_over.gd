extends Control

@export var confirm_sound:AudioStream
@export var move_sound:AudioStream

@onready var title: Label = $BG/Title

const MainMenuPath:String = "res://scenes/MainMenu/MainMenu.tscn"
const GamePath:String = "res://scenes/Game/Game.tscn"

var loser: Player
var player_P1: Player
var player_P2: Player


func animate_ui_elastic_fade_in(
	node_to_animate: Control, # 传入你需要动画的UI节点，比如Panel, Button等
	start_scale: Vector2 = Vector2(0.5, 0.5), # 动画开始时的缩放大小
	end_scale: Vector2 = Vector2(1.0, 1.0),   # 动画结束时的缩放大小
	duration: float = 0.4, # 动画持续时间
	fade_delay: float = 0.1, # 透明度动画的延迟
	start_alpha: float = 0.0, # 动画开始时的透明度
	end_alpha: float = 1.0    # 动画结束时的透明度
) -> Tween:
	"""
	创建一个Tween动画，实现UI节点的弹性变出和透明度渐变。
	
	参数:
		node_to_animate: 要进行动画的Control节点。
		start_scale: 动画开始时节点的缩放。
		end_scale: 动画结束时节点的缩放。
		duration: 弹性动画的持续时间。
		fade_delay: 透明度动画相对于缩放动画的延迟。
		start_alpha: 动画开始时节点的透明度。
		end_alpha: 动画结束时节点的透明度。
		
	返回:
		创建的Tween对象，你可以用它来连接信号或者检查动画状态。
	"""
	
	# 确保节点存在且是Control类型，因为我们需要操作它的scale和modulate
	if not node_to_animate or not node_to_animate is Control:
		push_error("animate_ui_elastic_fade_in: 传入的节点无效或不是Control类型！")
		return null

	# 如果节点是隐藏的，先让它可见
	node_to_animate.visible = true

	# 创建一个新的Tween
	var tween = create_tween()

	# 设置动画模式为并行，这样缩放和透明度可以同时进行
	tween.set_parallel(true)

	# 1. 缩放动画 (弹性变出效果)
	# 设置初始缩放
	node_to_animate.scale = start_scale
	# 动画到最终缩放，使用TRANS_ELASTIC插值和EASE_OUT缓动，制造弹性效果
	tween.tween_property(node_to_animate, "scale", end_scale, duration)\
		.set_trans(Tween.TRANS_ELASTIC)\
		.set_ease(Tween.EASE_OUT)

	# 2. 透明度动画
	# 设置初始透明度（通过modulate属性的alpha通道）
	var start_color = node_to_animate.modulate
	start_color.a = start_alpha
	node_to_animate.modulate = start_color
	
	var end_color = node_to_animate.modulate
	end_color.a = end_alpha
	
	# 动画到最终透明度，使用TRANS_SINE插值和EASE_IN_OUT缓动，并设置延迟
	tween.tween_property(node_to_animate, "modulate:a", end_alpha, duration - fade_delay)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)\
		.set_delay(fade_delay) # 延迟一点点，让缩放先开始
	
	return tween

func set_result(player_id, player1, player2):
	loser = player_id
	player_P1 = player1
	player_P2 = player2

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	set_title()
	var bg: Panel = $BG
	animate_ui_elastic_fade_in(bg)


func set_title():
	if loser == player_P1:
		title.text = "恭喜红方获胜"
	else:
		title.text = "恭喜蓝方获胜"

func _on_comfirm_pressed() -> void:
	AudioManager.play_sfx(confirm_sound)
	get_tree().change_scene_to_file(MainMenuPath)
	CountInstance.created = false
	queue_free()

func _on_quit_pressed() -> void:
	AudioManager.play_sfx(confirm_sound)
	get_tree().reload_current_scene()
	CountInstance.created = false
	queue_free()


func _on_comfirm_mouse_entered() -> void:
	AudioManager.play_sfx(move_sound)

func _on_quit_mouse_entered() -> void:
	AudioManager.play_sfx(move_sound)
