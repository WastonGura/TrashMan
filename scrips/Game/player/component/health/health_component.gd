class_name HealthComponent extends Node2D

@export var HP:int = 100
@export var max_HP = 100
@export var min_HP = 0
@export var current_lives: int = 5

signal damage_over(damage, is_shield)
signal player_die
signal get_hurt(damage)

const DamageNumberScene = preload("res://scenes/Characters/damage_number.tscn")


func _process(_delta: float) -> void:
	check_death()

func get_HP() -> int:
	return HP

func set_HP(new_HP) -> void:
	HP = new_HP

func health_player(value:float, duration:float = 0) -> void:
	var current_hp = get_HP()
	var new_hp = current_hp + value
	new_hp = clampf(new_hp, min_HP, max_HP)
	if duration <= 0:
		set_HP(new_hp)
		return
	var tween:Tween = create_tween()
	tween.tween_property(self, "HP", new_hp, duration)

func take_damage(damage,is_shield_box) -> void:
	var parent = get_parent()
	if is_shield_box:
		if parent.has_node("component/DefendComponent"):
			var defend_component = parent.get_node("component/DefendComponent")
			damage = defend_component.defend(damage)
	else:
		emit_signal("get_hurt")
	var new_HP = get_HP() - damage
	new_HP = max(new_HP, 0)
	set_HP(new_HP)
	emit_signal("damage_over", damage, is_shield_box)
	show_damage_number(damage, parent.global_position)

func check_death() -> void:
	var current_HP = get_HP()
	if current_HP <= 0:
		emit_signal("player_die")
	else:
		pass

# 生成伤害数值的核心函数
func show_damage_number(amount: int, spawn_position: Vector2, color:Color = Color.WHITE):
	# 1. 实例化我们创建的伤害数值场景
	var damage_number = DamageNumberScene.instantiate()

	# 2. 将实例化的节点添加到场景树中
	#    建议添加到 get_parent() 或者一个专门的 UI 层，以避免它跟随角色一起旋转
	get_parent().add_child(damage_number)
	
	# 3. 设置它的初始位置
	#    可以加一点随机偏移，让数字不完全重叠
	var offset = Vector2(randf_range(-15, 15), randf_range(-15, 0))
	damage_number.global_position = spawn_position + offset

	# 4. 调用它的 start 函数，启动动画！
	#    这里我们可以根据伤害类型改变颜色，比如暴击是红色
	damage_number.start(-amount, color)


## 测试：按下 UI_ACCEPT 键（通常是空格或回车）就扣血
#func _unhandled_input(event):
	#if event.is_action_pressed("ui_accept"):
		#take_damage(randi_range(5, 20)) # 造成 5-20 的随机伤害
