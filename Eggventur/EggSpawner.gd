extends Node3D

@export var egg_scene: PackedScene = load("res://Egg.tscn")
@export var golden_egg: PackedScene = load("res://GoldenEgg.tscn")  # NEW

@export var max_eggs := 10
@export var wall_margin := 3.0

var current_eggs := 0

# ───────────── WALL LIMITS ─────────────
const WALL_MARGIN = 2.0
const MIN_X := -56.99 + WALL_MARGIN
const MAX_X := 10.226 - WALL_MARGIN
const MIN_Z := -41.90 + WALL_MARGIN
const MAX_Z := 26.065 - WALL_MARGIN

@onready var golden_timer: Timer = $GoldenTimer  # NEW: You'll add this node next

func _ready():
	$Timer.timeout.connect(spawn_egg)
	
	# NEW: Golden egg setup (every 30s)
	golden_timer.wait_time = 30.0
	golden_timer.autostart = true
	golden_timer.one_shot = false
	golden_timer.timeout.connect(spawn_golden_egg)
	
	print("EggSpawner ready")

func spawn_egg():
	if current_eggs >= max_eggs:
		return
	
	var egg = egg_scene.instantiate()
	_spawn_at_random_position(egg)
	add_child(egg)
	current_eggs += 1
	
	egg.tree_exited.connect(func():
		current_eggs -= 1
	)

# NEW: Spawn golden egg (no limit, independent)
func spawn_golden_egg():
	if not golden_egg:
		return
	
	var golden_egg = golden_egg.instantiate()
	_spawn_at_random_position(golden_egg)
	add_child(golden_egg)

# NEW: Helper for random safe position (used by both)
func _spawn_at_random_position(instance: Node3D):
	var spawn_x := randf_range(
		MIN_X + wall_margin,
		MAX_X - wall_margin
	)
	var spawn_z := randf_range(
		MIN_Z + wall_margin,
		MAX_Z - wall_margin
	)
	instance.global_position = Vector3(
		spawn_x,
		0.25,  # Height above floor
		spawn_z
	)
