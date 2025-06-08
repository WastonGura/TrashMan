extends Control

@export var confirm_sound:AudioStream
@export var move_sound:AudioStream

# 导入区
## 节点
@onready var title: Label = $BG/Title
@onready var comfirm: Button = $BG/Comfirm
@onready var quit: Button = $BG/Quit
@onready var bg: Panel = $BG

func _ready() -> void:
	animate_ui_elastic_fade_in(bg)

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

# 信号接收区
## 取消按钮
func _on_quit_pressed() -> void:
	CountInstance.created = false
	AudioManager.play_sfx(confirm_sound)
	queue_free()

## 确认按钮
func _on_comfirm_pressed() -> void:
	CountInstance.created = false
	AudioManager.play_sfx(confirm_sound)
	queue_free()
	get_tree().quit()


func _on_quit_mouse_entered() -> void:
	AudioManager.play_sfx(move_sound)

func _on_comfirm_mouse_entered() -> void:
	AudioManager.play_sfx(move_sound)
