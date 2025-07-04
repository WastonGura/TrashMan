extends Node2D

@onready var pet: Polygon2D = $"../../sceneroot/Polygon/Modle/pet2"
@onready var remote_attack_timer: Timer = $remote_attack_timer
@onready var hip: Bone2D = $"../../sceneroot/Polygon/Skeleton2D/hip"

@export var player: Player
@export var player_control: PlayerControl

const PETPATH = preload("res://scenes/Characters/Pot.tscn")

signal pet_created(pet)


func create_pet():
	var pet_instance = PETPATH.instantiate()
	pet_instance.flight_component.set_direction(hip.scale.x)
	pet_instance.flight_attack_component.set_ATK(player_control.RemoteATK)
	pet_instance.scale.x = hip.scale.x
	pet_instance.global_position = player.global_position + Vector2(50,0) * hip.scale.normalized()
	pet_instance.flight_attack_component.player_id = player
	emit_signal("pet_created", pet_instance)

func _process(_delta: float) -> void:
	if player_control.has_pot:
		pet.visible = true

func _input(event):
		if event.is_action_pressed(player.remote_attack_action):
			player.change_state("remote_attack")

func _on_remote_attack_state_entered() -> void:
	remote_attack_timer.start()
	player_control.is_action = true
	player.animation_tree.set("parameters/BlendTree/Action/blend_position", Vector2(1.0, 0.0))
	player.animation_tree["parameters/BlendTree/ActionOneShot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
	create_pet()

func _on_remote_attack_state_exited() -> void:
	player_control.is_action = false

func _on_remote_attack_timer_timeout() -> void:
	player.change_state("idle")
