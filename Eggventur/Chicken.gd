# Updated Player.gd (NO instant refill → NO "jump to full"! + Own max_stamina logic)
extends CharacterBody3D

signal hit

@export var speed := 14.0
@export var sprint_multiplier := 1.8
@export var jump_impulse := 20.0
@export var fall_acceleration := 75.0

@export var base_max_stamina := 100.0  
@export var stamina_drain_rate := 25.0
@export var stamina_regen_rate := 2.0

var max_stamina := 100.0
var stamina := 100.0
var eggs_collected := 0

@onready var egg_label: Label = get_node("/root/Main/UserInterface/EggLabel")
@onready var stamina_bar: ProgressBar = get_node("/root/Main/UserInterface/StaminaBar")
@onready var egg_sound: AudioStreamPlayer3D = $EggSound
@onready var levelup_sound: AudioStreamPlayer3D = $LevelUpSound
@onready var anim: AnimationPlayer = $Pivot/CHICKEN/AnimationPlayer
@onready var pivot: Node3D = $Pivot

var was_on_floor := true

func _ready():
	update_max_stamina()  # Sets initial max_stamina
	stamina = max_stamina
	update_stamina_bar()

func update_max_stamina():
	# GRADUAL growth every egg: +5 max stamina per egg (25/5)
	max_stamina = base_max_stamina + (eggs_collected / 5.0) * 25.0

func _physics_process(delta):
	var direction := Vector3.ZERO
	
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
	if Input.is_action_pressed("move_back"):
		direction.z += 1
	
	# SPRINT/STAMINA (unchanged)
	var attempting_sprint := Input.is_action_pressed("sprint")
	var is_sprinting := attempting_sprint and stamina > 0.1
	var current_speed := speed
	
	if attempting_sprint:
		if stamina > 0.1:
			current_speed *= sprint_multiplier
			stamina -= stamina_drain_rate * delta
			stamina = max(0.0, stamina)
	else:
		stamina += stamina_regen_rate * delta
		stamina = min(max_stamina, stamina)
	
	update_stamina_bar()
	
	var on_floor := is_on_floor()
	
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		var facing_angle := atan2(direction.x, direction.z) + PI
		pivot.rotation.y = lerp_angle(pivot.rotation.y, facing_angle, delta * 15.0)
	
	if on_floor:
		if direction != Vector3.ZERO:
			if is_sprinting:
				play_anim("walk01", 3.5)
			else:
				play_anim("walk01", 2.5)
		else:
			play_anim("idle01", 1.0)
	
	velocity.x = direction.x * current_speed
	velocity.z = direction.z * current_speed
	
	if on_floor and Input.is_action_just_pressed("jump"):
		velocity.y = jump_impulse
		play_anim("bunnyhop", 1.5)
	
	velocity.y -= fall_acceleration * delta
	move_and_slide()
	
	if not was_on_floor and on_floor:
		play_anim("idle01", 1.0)
	was_on_floor = on_floor
	
	for i in range(get_slide_collision_count()):
		var collider = get_slide_collision(i).get_collider()
		if collider and collider.is_in_group("mob"):
			die()
			return
	
	pivot.rotation.x = PI / 6 * velocity.y / jump_impulse

func play_anim(name: String, speed_scale := 1.0):
	if anim.current_animation != name:
		anim.play(name)
	anim.speed_scale = speed_scale

func update_stamina_bar():
	stamina_bar.value = (stamina / max_stamina) * 100.0

# FIXED: Gradual max_stamina growth + NO REFILL = NO JUMPS!
func collect_egg():
	eggs_collected += 1
	egg_label.text = "Eggs: %d" % eggs_collected
	
	# Update max_stamina GRADUALLY every egg
	update_max_stamina()
	
	# Update mob difficulty on Main
	get_node("/root/Main").update_difficulty_by_eggs(eggs_collected)
	
	if eggs_collected % 5 == 0:
		levelup_sound.play()  # Just sound reward!
	else:
		egg_sound.play()

func die():
	hit.emit()
	queue_free()
