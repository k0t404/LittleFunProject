extends CharacterBody3D


var make_your_shot: bool = false

func _physics_process(delta: float) -> void:
	$WeaponMesh/AnimationTree.set("parameters/conditions/idle", !make_your_shot)
	$WeaponMesh/AnimationTree.set("parameters/conditions/shoot", make_your_shot)
	move_and_slide()
#func _physics_process(delta: float) -> void:
	## Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta
#
	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
#
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	#var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	#if direction:
		#velocity.x = direction.x * SPEED
		#velocity.z = direction.z * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
		#velocity.z = move_toward(velocity.z, 0, SPEED)
#
	#move_and_slide()
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack") and !make_your_shot:
		print(1)
		make_your_shot = true
		await get_tree().create_timer(2).timeout
		print(2)
		make_your_shot = false
