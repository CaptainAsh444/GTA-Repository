extends CharacterBody3D

@export var speed := 100
@export var gravity := -100
@export var jumpHeight := 10
@onready var neck: Node3D = $neck
@onready var cam: Camera3D = $neck/Camera3D
@export var sens = -0.01

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
	velocity *= 0.8
	move_and_slide()
	pass
