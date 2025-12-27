extends Node3D

@export var egg_scene: PackedScene
@export var max_eggs := 10
@export var wall_margin := 3.0

var current_eggs := 0

# Wall limits (from your scene)
const WALL_MARGIN = 2.0
const MIN_X = -20.46 + WALL_MARGIN
const MAX_X =  21.689 - WALL_MARGIN
const MIN_Z = -18.0  + WALL_MARGIN
const MAX_Z =  12.302 - WALL_MARGIN


func _ready():
	$Timer.timeout.connect(spawn_egg)
	print("EggSpawner ready")

func spawn_egg():
	if current_eggs >= max_eggs:
		return

	print("Spawning egg")

	var egg = egg_scene.instantiate()

	var spawn_x = randf_range(
		MIN_X + wall_margin,
		MAX_X - wall_margin
	)

	var spawn_z = randf_range(
		MIN_Z + wall_margin,
		MAX_Z - wall_margin
	)

	egg.global_position = Vector3(
		spawn_x,
		0.25,   # 👈 IMPORTANT: height above floor
		spawn_z
	)

	add_child(egg)
	current_eggs += 1

	egg.tree_exited.connect(func(): current_eggs -= 1)
