extends Control

# 通过 @onready 提前获取 Label 节点的引用
@onready var label: Label = $Label

# 动画的持续时间（秒）
const DURATION = 0.8
# 数字向上飘动的距离（像素）
const FLOAT_HEIGHT = 60

# 启动动画的函数
# amount: 要显示的伤害数值
# color: 数字的颜色
func start(amount: int, color: Color):
	# 1. 设置文本和颜色
	label.text = str(amount)
	label.modulate = color

	# 2. 创建一个 Tween 动画控制器
	var tween = create_tween()
	
	# 让补间动画并行执行（移动和消失同时进行）
	tween.set_parallel(true)

	# 3. 创建位移动画
	# 让 DamageNumber 节点在 DURATION 秒内，Y 坐标向上移动 FLOAT_HEIGHT 的距离
	tween.tween_property(self, "position:y", position.y - FLOAT_HEIGHT, DURATION).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)

	# 4. 创建淡出动画
	# 让 DamageNumber 节点在 DURATION 秒内，透明度（modulate.a）从 1 变为 0
	tween.tween_property(self, "modulate:a", 0.0, DURATION)

	# 5. 等待动画播放完毕
	await tween.finished

	# 6. 动画结束后，销毁自身，释放内存
	queue_free()
