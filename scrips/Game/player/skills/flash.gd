extends Node

@export var flight_attack_component: FlightAttackComponent
@export var timer: Timer
@export var animation_player: AnimationPlayer
@export var flash_audio_stream: AudioStream


func _ready() -> void:
	flash_start()

func flash_start():
	timer.start()
	AudioManager.play_sfx(flash_audio_stream)
	animation_player.play("FlashAnimation/Flash")

func _on_timer_timeout() -> void:
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Hitbox"):
		flight_attack_component.attack(area)
	elif area.is_in_group("Shieldbox"):
		flight_attack_component.attack(area)
