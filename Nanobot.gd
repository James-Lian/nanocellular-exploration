extends KinematicBody2D

var speed = 300
var increasing_speed = 0
const ACCELERATION = 500
const FRICTION = 500

var velocity = Vector2.ZERO

var rot_dir = 0
var rotation_speed = 4

func _ready():
	pass

func _physics_process(delta):
	rot_dir = 0
	
	if Input.is_action_pressed("turn_left"):
		rot_dir -= 1
	elif Input.is_action_pressed("turn_right"):
		rot_dir += 1
	
	rotation += rotation_speed * rot_dir * delta
	
	if Input.is_action_pressed("forward"):
		increasing_speed -= ACCELERATION * delta
		increasing_speed = clamp(increasing_speed, -speed, 0)
		velocity = Vector2(0, increasing_speed).rotated(rotation)
	elif Input.is_action_pressed("back"):
		increasing_speed += ACCELERATION * delta
		increasing_speed = clamp(increasing_speed, 0, speed)
		velocity = Vector2(0, increasing_speed).rotated(rotation)
	else:
		if increasing_speed > 0:
			increasing_speed -= FRICTION * delta
			increasing_speed = clamp(increasing_speed, 0, speed)
			velocity = Vector2(0, increasing_speed).rotated(rotation)
		elif increasing_speed < 0:
			increasing_speed += FRICTION * delta
			increasing_speed = clamp(increasing_speed, -speed, 0)
			velocity = Vector2(0, increasing_speed).rotated(rotation)
	
	if velocity == Vector2.ZERO:
		$Particles2D.emitting = false
	else:
		$Particles2D.emitting = true

	velocity = move_and_slide(velocity)


