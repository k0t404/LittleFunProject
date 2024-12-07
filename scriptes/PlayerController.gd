extends CharacterBody3D

var direction: Vector3; var inputDirection: Vector2; var slideDirection: Vector3

var currentSpeed: float; var walkSpeed: float; var jumpVelocity: float = 4.5;
var runSpeed: float; var crouchSpeed: float

var moving: bool; var running: bool; var able_to_run: bool; var crouching: bool;
var sliding: bool;

var heightNormal: float; var heightCrouch: float; var heightSlide: float

var fovNormal: float; var fovCrouch: float; var fovRun: float

var cb_pos: Vector3; var cb_time: float; var cb_frequency: float; var cb_amplitude: float

var current_weapon_type: String = "revolver"

var gravity: float = 9.8;

@onready var PlayerStamina = preload("res://scenes and presets/PlayerStamina.gd").new()
@onready var head = $"Head"; @onready var camera = $"Head/Camera3D"
@onready var sensitivity: float = 0.001
@onready var weapon = $"Head/Camera3D/Weapon"

func _ready():
	walkSpeed = 5; runSpeed = 10; crouchSpeed = 2;
	heightNormal = 2; heightCrouch = 0.3; heightSlide = 0.2
	fovCrouch = 3; fovNormal = 3; fovRun = 20
	cb_amplitude = 0.08; cb_frequency = 6
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * sensitivity)
		camera.rotate_x(-event.relative.y * sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		_attack()

var bullet_hole = preload("res://scenes and presets/bullet_hole.tscn")

func _attack() -> void:
	var distanceOfRay = 1000
	var space_state = camera.get_world_3d().direct_space_state
	var screen_center = get_viewport().size / 2
	var origin = camera.project_ray_origin(screen_center)
	var end = origin + camera.project_ray_normal(screen_center) * distanceOfRay
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_bodies = true
	var result = space_state.intersect_ray(query)
	if result:
		if current_weapon_type == "revolver":
			raycast_bullethole(result["position"])

func raycast_bullethole(position:Vector3) -> void:
	var instance = bullet_hole.instantiate()
	get_tree().root.add_child(instance)
	instance.global_position = position
	await get_tree().create_timer(0.1).timeout
	instance.queue_free()

func _physics_process(delta):
	move(delta)	
	#print(currentSpeed)
	run()
	crouch()
	headbob(0.005)
	#slide()
	#
	#if !sliding:
	#	run()
	#	crouch()
	
func move(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	if !sliding:		
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = jumpVelocity
	
		inputDirection = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
		direction = (head.transform.basis * Vector3(inputDirection.x, 0, inputDirection.y)).normalized()
	
		if direction:
			moving = true
			if !running && !crouching && !sliding && currentSpeed < 5:
				
				currentSpeed = lerp(currentSpeed, walkSpeed, 0.06)
			if !running && !crouching && !sliding && currentSpeed >= 5:
				
				currentSpeed = lerp(currentSpeed, walkSpeed, 0.01)
		else:
			moving = false
			currentSpeed = 0
			
		velocity.x = direction.x * currentSpeed
		velocity.z = direction.z * currentSpeed
		
	
	move_and_slide()
	
func run():
	if able_to_run && moving && PlayerStamina.stamina > 5 && Input.is_action_just_pressed("run"):
		
		running = true
	elif Input.is_action_just_released("run") or PlayerStamina.stamina <= 5:
		if PlayerStamina.stamina <= 30:
			able_to_run = false
		else:
			able_to_run = true
		running = false
	if running:
		PlayerStamina.stamina_change(0, 0.01)
		currentSpeed = lerp(currentSpeed, runSpeed, 0.04)
	else:
		PlayerStamina.stamina_change(100, 0.01)
	


func crouch():
	if !running && Input.is_action_just_pressed("crouch"):
		crouching = true
		
	elif Input.is_action_just_released("crouch"):
		crouching = false
	
	if crouching:
		$"CollisionShape3D".shape.height = height_change(heightCrouch, 0.09)
		currentSpeed = lerp(currentSpeed, crouchSpeed, 0.07)
	else:
		$"CollisionShape3D".shape.height = height_change(heightNormal, 0.06)
	
		
func height_change(height_new, coeficient):
	return lerp($"CollisionShape3D".shape.height, height_new, coeficient)

func slide():
	if currentSpeed > 8.7 && Input.is_action_just_pressed("crouch"):
		sliding = true; currentSpeed = runSpeed + crouchSpeed * 2
	
	if sliding && Input.is_action_just_released("crouch"):
		sliding = false;
	
	if sliding && currentSpeed > 3:
		slideDirection = (-camera.global_transform.basis.z.normalized()) * currentSpeed
		velocity.x = slideDirection.x
		velocity.z = slideDirection.z
		
		currentSpeed = lerp(currentSpeed, crouchSpeed, 0.07)
		$"CollisionShape3D".shape.height = height_change(heightSlide, 0.09)
		
	else:
		sliding = false
		crouching = false
		
func fov_change(fov_new) -> float:
	return lerp(camera.fov, fov_new, 0.03)	
	
func headbob(delta):
	cb_time += delta * velocity.length() * float(is_on_floor())
	cb_pos = Vector3.ZERO
	cb_pos.y = sin(cb_time * cb_frequency) * cb_amplitude
	cb_pos.x = cos(cb_time * cb_frequency / 2) * cb_amplitude
	camera.transform.origin = cb_pos
