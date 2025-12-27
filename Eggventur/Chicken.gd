extends CharacterBody3D

signal hit

@export var speed := 14.0
@export var jump_impulse := 20.0
@export var fall_acceleration := 75.0

var eggs_collected := 0

@onready var egg_label: Label = get_node("/root/Main/UserInterface/EggLabel")
@onready var egg_sound: AudioStreamPlayer3D = $EggSound
@onready var levelup_sound: AudioStreamPlayer3D = $LevelUpSound
@onready var anim: AnimationPlayer = $Pivot/CHICKEN/AnimationPlayer
@onready var pivot: Node3D = $Pivot

var was_on_floor := true

func _physics_process(delta):
	var direction := Vector3.ZERO

	# ───────────── INPUT ─────────────
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
	if Input.is_action_pressed("move_back"):
		direction.z += 1

	var on_floor := is_on_floor()

	# ───────────── ROTATION + ANIMATION ─────────────
	if direction != Vector3.ZERO:
		direction = direction.normalized()

		# Face EXACT movement direction (fixes up/down)
		var facing_angle := atan2(direction.x, direction.z) + PI
		pivot.rotation.y = lerp_angle(
			pivot.rotation.y,
			facing_angle,
			delta * 15.0
		)

		if on_floor:
			play_anim("walk01", 2.5)
	else:
		if on_floor:
			play_anim("idle01", 1.0)

	# ───────────── MOVEMENT ─────────────
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed

	if on_floor and Input.is_action_just_pressed("jump"):
		velocity.y = jump_impulse
		play_anim("bunnyhop", 1.5)

	velocity.y -= fall_acceleration * delta
	move_and_slide()

	# ───────────── LANDING ─────────────
	if not was_on_floor and on_floor:
		play_anim("idle01", 1.0)
	was_on_floor = on_floor

	# ───────────── COLLISION ─────────────
	for i in range(get_slide_collision_count()):
		var collider = get_slide_collision(i).get_collider()
		if collider and collider.is_in_group("mob"):
			die()
			return

	# ───────────── JUMP TILT (CHICKEN ONLY) ─────────────
	pivot.rotation.x = PI / 6 * velocity.y / jump_impulse


func play_anim(name: String, speed_scale := 1.0):
	if anim.current_animation != name:
		anim.play(name)
	anim.speed_scale = speed_scale


func collect_egg():
	eggs_collected += 1
	egg_label.text = "Eggs: %d" % eggs_collected

	if eggs_collected % 5 == 0:
		levelup_sound.play()
	else:
		egg_sound.play()

	get_node("/root/Main").update_difficulty_by_eggs(eggs_collected)


func die():
	hit.emit()
	queue_free()
