extends Node3D

@export var egg_scene: PackedScene = load("res://Egg.tscn")
@export var max_eggs := 10
@export var wall_margin := 3.0

var current_eggs := 0

# ───────────── NEW WALL LIMITS ─────────────
const WALL_MARGIN = 2.0
const MIN_X := -56.99 + WALL_MARGIN
const MAX_X :=  10.226 - WALL_MARGIN
const MIN_Z := -41.90 + WALL_MARGIN
const MAX_Z :=  26.065 - WALL_MARGIN


func _ready():
	$Timer.timeout.connect(spawn_egg)
	print("EggSpawner ready")


func spawn_egg():
	if current_eggs >= max_eggs:
		return

	var egg = egg_scene.instantiate()

	var spawn_x := randf_range(
		MIN_X + wall_margin,
		MAX_X - wall_margin
	)

	var spawn_z := randf_range(
		MIN_Z + wall_margin,
		MAX_Z - wall_margin
	)

	egg.global_position = Vector3(
		spawn_x,
		0.25,   # height above floor
		spawn_z
	)

	add_child(egg)
	current_eggs += 1

	# Decrease count when egg is collected / freed
	egg.tree_exited.connect(func():
		current_eggs -= 1
	)
