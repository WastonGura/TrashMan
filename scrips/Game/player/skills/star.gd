extends Area2D

@export var animation_player: AnimationPlayer
@export var flight_component: FlightComponent
@export var flight_attack_component: FlightAttackComponent
@export var stars_audio_stream:AudioStream

func _ready() -> void:
	flight_attack_component.connect("attack_over", Callable(flight_component, 'destroy'))
	start()

func start() -> void:
	animation_player.play("StarAnimation/Star")
	AudioManager.play_sfx(stars_audio_stream)

func _process(_delta: float) -> void:
	pass

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Hitbox"):
		flight_attack_component.attack(area)
	elif area.is_in_group("Shieldbox"):
		flight_attack_component.attack(area)
	elif area.is_in_group("Wall"):
		flight_component.destroy()
