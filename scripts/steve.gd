extends PortalTraveler

var camera_angle = 0
var mouse_sensitivity = 0.005
var camera_change = Vector2()

var velocity = Vector3()

const FLY_ACCEL = 4
const FLY_SPEED = 20

var gravity = -9.8 * 3
const MAX_SPEED = 20
const MAX_RUNNING_SPEED = 5
const ACCEL = 2
const DEACCEL = 6

var jump_height = 15
var has_contact = false

const MAX_SLOPE_ANGLE = Constants.QUARTER_PI

func _ready():
	pass

func _physics_process(delta):
	aim()
	walk(delta)

func _input(event):
	if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
		return
	
	if event is InputEventMouseMotion:
		camera_change = event.relative

func fly(delta):
	var direction = Vector3()
	
	var aim = $Head/Camera.get_global_transform().basis
	if Input.is_action_pressed("move_up"):
		direction -= aim.z
	if Input.is_action_pressed("move_down"):
		direction += aim.z
	if Input.is_action_pressed("move_left"):
		direction -= aim.x
	if Input.is_action_pressed("move_right"):
		direction += aim.x
	
	direction = direction.normalized()
	
	var target = direction*FLY_SPEED
	velocity = velocity.linear_interpolate(target, FLY_ACCEL*delta)
	
	move_and_slide(velocity)

func walk(delta):
	var direction = Vector3()
	
	var aim = $Head/Camera.get_global_transform().basis
	if Input.is_action_pressed("move_up"):
		direction -= aim.z
	if Input.is_action_pressed("move_down"):
		direction += aim.z
	if Input.is_action_pressed("move_left"):
		direction -= aim.x
	if Input.is_action_pressed("move_right"):
		direction += aim.x
	direction.y = 0
	direction = direction.normalized()
	
	if(is_on_floor()):
		has_contact = true
		var n = $DownRay.get_collision_normal()
		var floor_angle = acos(n.y)
		if floor_angle > MAX_SLOPE_ANGLE:
			velocity.y += gravity * delta
		else:
			velocity.y -= 0.01*delta
	else:
		if !$DownRay.is_colliding():
			has_contact = false
		velocity.y += gravity * delta

	if has_contact and !is_on_floor():
		move_and_collide(Vector3(0,-1,0))
	
	
	var temp_vel = velocity
	temp_vel.y = 0
	
	var speed
	if Input.is_action_pressed("sprint"):
		speed = MAX_RUNNING_SPEED
	else:
		speed = MAX_SPEED
	
	var target = direction*speed
	
	var acceleration
	if direction.dot(temp_vel) > 0:
		acceleration = ACCEL
	else:
		acceleration = DEACCEL
	
	temp_vel = temp_vel.linear_interpolate(target, acceleration*delta)
	
	velocity.x = temp_vel.x
	velocity.z = temp_vel.z
	
	if has_contact and Input.is_action_just_pressed("jump"):
		velocity.y = jump_height
		has_contact = false
		
	velocity = move_and_slide(velocity, Vector3(0,1,0))

func aim():
	if camera_change.length() > 0:
		rotate_y(-camera_change.x*mouse_sensitivity)
		
		var change = -camera_change.y*mouse_sensitivity
		if -Constants.HALF_PI < change + camera_angle and change + camera_angle < Constants.HALF_PI: 
			$Head/Camera.rotate_x(change)
			camera_angle += change
	camera_change = Vector2()
