extends Node2D

@export var player: Player
@export var player_control: PlayerControl

@onready var close_timer: Timer = $close_timer
@onready var hurtbox: Area2D = $"../../Area/Hurtbox"

func _process(_delta: float) -> void:
	pass

func _input(event):
	if player_control.can_control:
		if event.is_action_pressed(player.close_attack_action):
			player.change_state("close_attack")

func _on_close_attack_state_entered() -> void:
	close_timer.start()
	hurtbox.monitorable = true
	hurtbox.monitoring = true
	player_control.is_action = true
	player.animation_tree.set("parameters/BlendTree/Action/blend_position", Vector2(-1.0, 0.0))
	player.animation_tree["parameters/BlendTree/ActionOneShot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
	player_control.close_attack_locker = 0.0


func _on_close_attack_state_exited() -> void:
	hurtbox.monitorable = false
	hurtbox.monitoring = false
	player_control.is_action = false

func _on_close_timer_timeout() -> void:
	player.change_state("idle")
