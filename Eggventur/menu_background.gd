extends Node

@export var mob_scene: PackedScene
@export var mob_min_speed := 5.0
@export var mob_max_speed := 10.0
@export var max_rocks := 20
@export var wall_margin := 3.0

var current_rocks := 0

# Background boundaries
const MIN_X = -25.0
const MAX_X = 25.0
const MIN_Z = -20.0
const MAX_Z = 15.0
const SPAWN_Y = 2.0  # height above floor

func _ready():
	$BackgroundMusic.play()
	$MobTimer.timeout.connect(_spawn_background_rock)

func _spawn_background_rock():
	if current_rocks >= max_rocks:
		return

	var rock = mob_scene.instantiate()
	rock.min_speed = mob_min_speed
	rock.max_speed = mob_max_speed

	# Random position inside background bounds
	var spawn_x = randf_range(MIN_X + wall_margin, MAX_X - wall_margin)
	var spawn_z = randf_range(MIN_Z + wall_margin, MAX_Z - wall_margin)
	rock.global_position = Vector3(spawn_x, SPAWN_Y, spawn_z)

	# Random horizontal direction
	var random_direction = Vector3(
		randf_range(-1, 1),
		-0.05,  # no vertical movement
		randf_range(-1, 1)
	).normalized()
	rock.velocity = random_direction * randf_range(mob_min_speed, mob_max_speed)

	add_child(rock)
	current_rocks += 1

	rock.tree_exited.connect(func(): current_rocks -= 1)
	
