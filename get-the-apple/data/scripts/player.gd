extends CharacterBody3D

@export var speed := 100
@export var gravity := -50
@export var jumpHeight := 20
@onready var neck: Node3D = $neck
@onready var cam: Camera3D = $neck/Camera3D
@export var sens = -0.01
var jumpBuffer := 0.0
var coyoteTime := 0.0
var friction := 0.8

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		neck.rotation.y += event.relative.x*sens
		cam.rotation.x += event.relative.y*sens
		cam.rotation.x = clamp(cam.rotation.x,deg_to_rad(-90),deg_to_rad(90))
	pass

func _physics_process(delta: float) -> void:
	velocity.y += gravity*delta
	var InputVec = Input.get_vector("left","right","up","down").normalized()
	var direction = (neck.transform.basis * transform.basis * Vector3(InputVec.x, 0, InputVec.y)).normalized()
	if direction:
		velocity += direction*speed*delta
	velocity *= Vector3(friction,1,friction)
	move_and_slide()
	if Input.is_action_just_pressed("jump"):
		jumpBuffer = 5
	if is_on_floor():
		coyoteTime = 5
	if jumpBuffer>0 and coyoteTime>0:
		jump()
		jumpBuffer = 0
		coyoteTime = 0
	jumpBuffer -= delta
	coyoteTime -= delta
	pass

func jump():
	velocity.y = jumpHeight
	pass
