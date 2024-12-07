extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


var direction: Vector2; var inputDirection: Vector2; var slideDirection: Vector2

var currentSpeed: float; var walkSpeed: float; var jumpVelocity: float = 4.5;
var runSpeed: float; var crouchSpeed: float

var moving: bool; var running: bool; var able_to_run: bool; var crouching: bool;
var sliding: bool;

var heightNormal: float; var heightCrouch: float; var heightSlide: float


var gravity: float = 9.8;

@onready var PlayerStamina = preload("res://scriptes2d/playerStamina_2d.gd").new()

func _ready():
	walkSpeed = 70; runSpeed = 140; crouchSpeed = 2; currentSpeed = walkSpeed
	heightNormal = 2; heightCrouch = 0.3; heightSlide = 0.2
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent) -> void:
	pass

func _physics_process(delta):
	move(delta)
	run()
	print(currentSpeed)
	

func move(delta):
	#if not is_on_floor():
		#velocity.y -= gravity * delta
	
	#if Input.is_action_just_pressed("jump") and is_on_floor():
		#velocity.y = jumpVelocity
	
	inputDirection = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	#direction = (Vector2(inputDirection.x, inputDirection.y)).normalized()
	
	if inputDirection:
		moving = true
		if !running && currentSpeed < 5:
			currentSpeed = lerp(currentSpeed, walkSpeed, 0.02)
		if !running && currentSpeed >= 5:
			currentSpeed = lerp(currentSpeed, walkSpeed, 0.015)
	else:
		moving = false
		currentSpeed = 0
	
	velocity = inputDirection * currentSpeed

	
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
