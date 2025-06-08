class_name Angle extends Area2D

@export var flight_attack_component: FlightAttackComponent
@export var flight_component: FlightComponent
@export var animation_player: AnimationPlayer
@export var angle_audio_stream: AudioStream

func _ready() -> void:
	flight_attack_component.connect("attack_over", Callable(flight_component, 'destroy'))
	start()

func start() -> void:
	animation_player.play("AngleAnimation/Angle")
	AudioManager.play_sfx(angle_audio_stream)

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Hitbox"):
		flight_attack_component.attack(area)
	elif area.is_in_group("Shieldbox"):
		flight_attack_component.attack(area)
	elif area.is_in_group("Wall"):
		flight_component.destroy()
