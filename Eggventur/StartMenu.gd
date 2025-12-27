extends Control

# Buttons
@onready var play_button: Button = $UI/PlayButton          # ← Must be directly under UI (moved out of Menu)
@onready var settings_button: Button = $UI/Menu/SettingsButton
@onready var controls_button: Button = $UI/Menu/ControlsButton
@onready var quit_button: Button = $UI/Menu/QuitButton

# Title
@onready var title_label: Label = $UI/Menu/Title

# Panels
@onready var settings_label: Label = $UI/SettingsLabel
@onready var volume_slider: HSlider = $UI/VolumeSlider
@onready var controls_label: Label = $UI/ControlsLabel

var in_submenu: bool = false
var main_menu_button_pos: Vector2
var main_menu_button_size: Vector2  # Store original size

func _ready():
	# Save original position and size from editor
	main_menu_button_pos = play_button.position
	main_menu_button_size = play_button.size
	
	play_button.grab_focus()
	
	volume_slider.value = 1.0
	AudioServer.set_bus_volume_db(0, linear_to_db(1.0))
	volume_slider.value_changed.connect(_on_volume_changed)
	
	show_main_menu()

func show_main_menu():
	in_submenu = false
	
	title_label.visible = true
	play_button.visible = true
	settings_button.visible = true
	controls_button.visible = true
	quit_button.visible = true
	
	settings_label.visible = false
	volume_slider.visible = false
	controls_label.visible = false
	
	play_button.text = "Play"
	play_button.position = main_menu_button_pos
	play_button.size = main_menu_button_size  # Restore normal size
	
	play_button.grab_focus()

func show_settings():
	in_submenu = true
	
	title_label.visible = false
	play_button.visible = true
	settings_button.visible = false
	controls_button.visible = false
	quit_button.visible = false
	
	settings_label.visible = true
	volume_slider.visible = true
	controls_label.visible = false
	
	play_button.text = "Back"
	play_button.position = Vector2(60, 520)  # Bottom-left
	play_button.size = Vector2(180, 60)      # ← Smaller size for Back button (adjust as you like)
	
	play_button.grab_focus()

func show_controls():
	in_submenu = true
	
	title_label.visible = false
	play_button.visible = true
	settings_button.visible = false
	controls_button.visible = false
	quit_button.visible = false
	
	controls_label.visible = true
	settings_label.visible = false
	volume_slider.visible = false
	
	play_button.text = "Back"
	play_button.position = Vector2(60, 520)  # Bottom-left
	play_button.size = Vector2(180, 60)      # ← Same smaller size
	
	play_button.grab_focus()

func _on_play_button_pressed():
	if in_submenu:
		show_main_menu()
	else:
		get_tree().change_scene_to_file("res://Main.tscn")

func _on_settings_button_pressed():
	show_settings()

func _on_controls_button_pressed():
	show_controls()

func _on_quit_button_pressed():
	get_tree().quit()

func _on_volume_changed(value: float):
	AudioServer.set_bus_volume_db(0, linear_to_db(value))
