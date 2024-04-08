extends CharacterBody2D


const SPEED = 100.0
const ACC = 800.0
const FRICTION = 1000.0
const JUMP_VELOCITY = -300.0
const  AIR_ACC = 400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	add_gravity(delta)
	handle_jump()
	var input_axis = Input.get_axis("left", "right")
	handle_acceleration(input_axis, delta)
	apply_friction(input_axis, delta)
	move_and_slide()

func add_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		
func handle_jump():
	if is_on_floor():
		if Input.is_action_just_pressed("up"):
			velocity.y = JUMP_VELOCITY
			
	else:
		if Input.is_action_just_released("up") and velocity.y < JUMP_VELOCITY / 2:
			velocity.y = JUMP_VELOCITY / 2
			
func apply_friction(input_axis, delta):
	if input_axis == 0 and is_on_floor():
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)


func handle_acceleration(input_axis, delta):
	if not is_on_floor(): return
	if input_axis != 0:
		velocity.x = move_toward(velocity.x, SPEED * input_axis, ACC * delta)
		
func handle_air_acceleration(input_axis, delta):
	if is_on_floor(): return
	if input_axis != 0:
		velocity.x = move_toward(velocity.x, SPEED * input_axis, AIR_ACC * delta)

