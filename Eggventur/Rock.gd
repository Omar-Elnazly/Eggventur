extends CharacterBody3D

@export var min_speed := 10.0
@export var max_speed := 18.0
@export var rock_radius := 0.5

var visual: Node3D
var last_position: Vector3


func _ready():
	visual = get_node_or_null("Pivot/Sphere")
	if visual == null:
		push_error("Mob.gd: Pivot/Sphere not found!")

	last_position = global_position


func _physics_process(delta):
	move_and_slide()
	if visual:
		roll_along_3d_movement()


func roll_along_3d_movement():
	var movement := global_position - last_position
	last_position = global_position

	if movement.length() < 0.001:
		return

	var dir := movement.normalized()
	var roll_axis := Vector3.UP.cross(dir)

	if roll_axis.length() < 0.001:
		return

	roll_axis = roll_axis.normalized()
	var angle := movement.length() / rock_radius

	visual.global_transform.basis = Basis(roll_axis, angle) * visual.global_transform.basis


func initialize(start_position: Vector3, player_position: Vector3):
	var target := Vector3(player_position.x, start_position.y, player_position.z)

	look_at_from_position(start_position, target, Vector3.UP)
	rotate_y(randf_range(-PI / 4.0, PI / 4.0))

	var speed := randf_range(min_speed, max_speed)
	velocity = Vector3.FORWARD * speed
	velocity = velocity.rotated(Vector3.UP, rotation.y)


func _on_visible_on_screen_notifier_screen_exited():
	queue_free()
