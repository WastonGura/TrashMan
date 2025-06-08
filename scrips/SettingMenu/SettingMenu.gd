extends Control

# 导入区
## 节点
@onready var bg: TextureRect = $BackGround/BG
@onready var container: Control = $Configs/Container


## 变量
var QuitMenuPath = preload("res://scenes/GameOver/QuitMenu.tscn")
var MainMenuPath = "res://scenes/MainMenu/MainMenu.tscn"
var LobbyMenuPath = "res://scenes/Lobby/LobbyMenu.tscn"

signal page_close

@export var bgm_progress_bar: ProgressBar
@export var sfx_progress_bar: ProgressBar
@export var voice_progress_bar: ProgressBar

@export var bgm_slider: HSlider
@export var sfx_slider: HSlider
@export var voice_slider: HSlider

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	voice_progress_bar.value = CountInstance.voice_db
	bgm_progress_bar.value = CountInstance.bgm_db
	sfx_progress_bar.value = CountInstance.sfx_db
	voice_slider.value = CountInstance.voice_db
	bgm_slider.value = CountInstance.bgm_db
	sfx_slider.value = CountInstance.sfx_db

# 功能区
## 显示退出游戏确认窗口
func show_quit_menu() -> void:
	var quit_menu = QuitMenuPath.instantiate()
	container.add_child(quit_menu)

# 信号接收区
## 退出游戏按钮
func _on_quit_pressed() -> void:
	if not CountInstance.created:
		show_quit_menu()
		CountInstance.created = true

func _on_home_pressed() -> void:
	emit_signal("page_close")
	self.queue_free()

func _on_bgm_slider_value_changed(value: float) -> void:
	CountInstance.bgm_db = value
	bgm_progress_bar.value = CountInstance.bgm_db
	AudioManager.set_volume(1,CountInstance.bgm_db)

func _on_sfx_slider_value_changed(value: float) -> void:
	CountInstance.sfx_db = value
	sfx_progress_bar.value = CountInstance.sfx_db
	AudioManager.set_volume(2,CountInstance.sfx_db)

func _on_voice_slider_value_changed(value: float) -> void:
	CountInstance.voice_db = value
	voice_progress_bar.value = CountInstance.voice_db
	AudioManager.set_volume(0, CountInstance.voice_db)
