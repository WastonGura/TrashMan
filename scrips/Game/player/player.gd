class_name Player
extends CharacterBody2D

@export var player_control: PlayerControl
@export var state_chart: StateChart
@export var player_id:int = 0
@export var player_type:String
@export var healeth_component: HealthComponent
@export var defend_component: DefendComponent
@export var attack_component: AttackComponent
@export var ep_component: EPComponent
@export var gravity_component: GravityComponent
@export var get_component: GetComponent
@export var buff_component: BuffComponent
@export var hip: Bone2D

@export var KaweiGameuse:AudioStream
@export var Persona:AudioStream
@export var HurtAudioStreamPlayer:AudioStream
@export var DieAudioStreamPlayer:AudioStream
@export var SoundEffect:AudioStream


@onready var animation_tree: AnimationTree = $AnimationTree
@export var skill: Node2D
@export var shield: Node2D
@onready var base_animation_state_machine:AnimationNodeStateMachinePlayback = animation_tree["parameters/BlendTree/BaseState/playback"]
@export var init: Node2D

@export var buff_container:HBoxContainer

@onready var foot_light: Sprite2D = $FootLight
@onready var sceneroot: Node2D = $sceneroot


var direction: Vector2

var root_node: Node2D

var close_attack_action: String
var remote_attack_action: String
var skill_action: String
var defend_action: String
var get_action: String
var parry_action: String
var jump_action: String
var left_run_action: String
var right_run_action: String

var is_burning: bool = false
var burn: bool = false

signal id_ready

func _ready() -> void:
	init_setting()
	init.burn()
	root_node = get_parent()
	healeth_component.connect("damage_over", Callable(self, "award"))

func _physics_process(_delta: float) -> void:
	move_and_slide()

func get_direction() -> float:
	return hip.scale.x

func set_player_id() -> String:
	var input_prefix = "P" + str(player_id)
	return input_prefix

func get_input_action(base_name: String, input_prefix: String) -> String:
	return "%s_%s" % [base_name, input_prefix]

func init_setting() -> void:
	var input_prefix = set_player_id()
	close_attack_action = get_input_action("CloseAttack", input_prefix)
	remote_attack_action = get_input_action("RemoteAttack", input_prefix)
	skill_action = get_input_action("Skill", input_prefix)
	defend_action = get_input_action("Defend", input_prefix)
	get_action = get_input_action("GetThings", input_prefix)
	parry_action = get_input_action("Catch", input_prefix)
	jump_action = get_input_action("Jump", input_prefix)
	left_run_action = get_input_action("LeftRun", input_prefix)
	right_run_action = get_input_action("RightRun", input_prefix)
	attack_component.set_ATK(player_control.NormalATK)
	defend_component.set_DEF(player_control.NormalDEF)
	emit_signal("id_ready")
	player_type = SettingManager.choose_type(str(player_id))
	_set_color(player_type)

func award(damage, is_shield):
	if not is_shield:
		var current_ep = ep_component.get_EP()
		var get_ep = damage * 0.2
		var new_ep = get_ep + current_ep
		ep_component.set_EP(new_ep)

func init_value():
	player_control.has_pot = true
	player_control.is_action = false

func _set_color(type:String) -> void:
	if type == "normal":
		return
	elif type == "harm":
		foot_light.self_modulate = Color("#ff503c")
		sceneroot.modulate = Color("#ff503c")
	elif type == "unrecycle":
		foot_light.self_modulate = Color("#b1ffae")
		sceneroot.modulate = Color("#b1ffae")
	elif type == "recycle":
		foot_light.self_modulate = Color("#2d78ff")
		sceneroot.modulate = Color("#2d78ff")
	elif type == "kitchen":
		foot_light.self_modulate = Color("#ffe72a")
		sceneroot.modulate = Color("#ffe72a")

func change_state(state:String):
	state_chart.send_event(state)
