extends CharacterBody3D


@export
var movementSpeed: float = 3.0
@export
var jumpVelocity: float = 10.0
@export
var gravityForce: float = 1
@export
var mouseSensativity: float = 0.5

var movementInputVector: Vector2 = Vector2(0, 0)
var currentYVelocity: float = 0

func _input(event):
	if event is InputEventMouseMotion:
		rotate(Vector3.UP, deg_to_rad(-event.relative.x * mouseSensativity))

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _physics_process(_delta):
	movementInputVector = Input.get_vector("move_right", "move_left", "move_backward", "move_forward") * movementSpeed
	if is_on_floor():
		currentYVelocity = 0
		if Input.is_action_just_pressed("jump"):
			currentYVelocity = jumpVelocity
		if Input.is_action_just_pressed("run"):
			movementSpeed = movementSpeed * 2
		if Input.is_action_just_released("run"):
			movementSpeed = movementSpeed / 2
	else:
		currentYVelocity = maxf(currentYVelocity - gravityForce, -2000)
	
	velocity = transform.basis * Vector3(movementInputVector.x, currentYVelocity, movementInputVector.y)
	
	move_and_slide()
