extends Node

@onready var time_label: Label = $UserInterface/TimeLabel
@onready var egg_label: Label = $UserInterface/EggLabel
@onready var retry_label: Label = $UserInterface/Retry/Label
@onready var egg_spawner_timer: Timer = $EggSpawner/Timer
@onready var lose_player: AudioStreamPlayer = $LosePlayer
@onready var mob_timer: Timer = $MobTimer

@export var mob_scene = load("res://Rock.tscn")

var mob_min_speed := 6.0
var mob_max_speed := 10.0

func _ready():
	$MusicPlayer.play()

	if RenderingServer.get_current_rendering_method() == "gl_compatibility":
		RenderingServer.directional_soft_shadow_filter_set_quality(
			RenderingServer.SHADOW_QUALITY_SOFT_HIGH
		)

		$DirectionalLight3D.sky_mode = DirectionalLight3D.SKY_MODE_SKY_ONLY
		var new_light: DirectionalLight3D = $DirectionalLight3D.duplicate()
		new_light.light_energy = 0.35
		new_light.sky_mode = DirectionalLight3D.SKY_MODE_LIGHT_ONLY
		add_child(new_light)

	$UserInterface/Retry.hide()

	# Start at EASY
	update_difficulty_by_eggs(0)

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and $UserInterface/Retry.visible:
		get_tree().reload_current_scene()

func _on_mob_timer_timeout():
	var mob = mob_scene.instantiate()
	mob.min_speed = mob_min_speed
	mob.max_speed = mob_max_speed

	var mob_spawn_location = get_node("SpawnPath/SpawnLocation")
	mob_spawn_location.progress_ratio = randf()

	var player_position = $Player.position
	mob.initialize(mob_spawn_location.position, player_position)

	add_child(mob)

# 🥚 DIFFICULTY EVERY 10 EGGS
func update_difficulty_by_eggs(eggs: int):
	var stage := eggs / 5   

	# Spawn faster every stage
	mob_timer.wait_time = max(0.4, 1.5 - stage * 0.3)

	# Rocks get faster every stage
	mob_min_speed = 6.0 + stage * 3.0
	mob_max_speed = 10.0 + stage * 4.0

func _on_player_hit():
	$MusicPlayer.stop()
	lose_player.play()

	mob_timer.stop()
	egg_spawner_timer.stop()

	time_label.hide()
	egg_label.hide()

	retry_label.text = (
		"Game Over!\nEggs: "
		+ str($Player.eggs_collected)
		+ "\nTime: "
		+ time_label.text
		+ "\n\nPress Enter to Retry"
	)

	$UserInterface/Retry.show()
