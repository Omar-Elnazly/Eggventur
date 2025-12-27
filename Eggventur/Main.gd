extends Node

@onready var time_label: Label = $UserInterface/TimeLabel
@onready var egg_label: Label = $UserInterface/EggLabel
@onready var retry_label: Label = $UserInterface/Retry/Label   # ← change "Label" to your actual label name inside Retry
@onready var egg_spawner_timer: Timer = $EggSpawner/Timer      # ← this stops eggs from spawning
@onready var lose_player: AudioStreamPlayer3D = $LosePlayer  # or $UserInterface/LosePlayer
@export var mob_scene = load("res://Rock.tscn")
var mob_min_speed := 10.0
var mob_max_speed := 18.0

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
	
func speed_up_rocks():
	# Make rocks spawn faster (reduce timer by 0.3 sec)
	$MobTimer.wait_time -= 0.3
	# Prevent timer from going too low or negative
	if $MobTimer.wait_time < 0.3:
		$MobTimer.wait_time = 0.3
	
	# Make future rocks move faster (increase their speed range)
	# These values are used when spawning new rocks
	mob_min_speed += 3.0
	mob_max_speed += 3.0


func _on_player_hit():
	$MusicPlayer.stop()
	lose_player.play()         # ← Plays lose music/sound
	
	$MobTimer.stop()                   # stops rocks
	egg_spawner_timer.stop() 
	
	# Hide the top-left HUD
	time_label.hide()
	egg_label.hide()
	
	# Show final score on Game Over screen
	retry_label.text = "Game Over!\nEggs: " + str($Player.eggs_collected) + "\nTime: " + time_label.text + "\n\nPress Enter to Retry"
	
	$UserInterface/Retry.show()
