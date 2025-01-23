@tool
extends CharacterBody3D

@onready var camera: Camera3D = $camera
@onready var wand:= $light

# globals for mouse control
@export var mouse_sensitivity = 0.004
@export var upDownMinAngle = -1.1
@export var upDownMaxAngle = 1.57

@export var mouse_active = false # handled by right mouse button

@export var strafe_speed = 2 		# units per second
@export var strafe_multiplier = 0.5 # increased on boost
@export var move_speed = 2 			# units per second
@export var move_multiplier = 0.5 	# increased on boost

@export var gravity = 9.8			# units per second per second
@export var jump_force = 5			# units per second

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# engine running?
	if Engine.is_editor_hint():
		return
	
	mouse_active = Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT)
	
	if Input.is_action_pressed("move boost"):
		strafe_multiplier = 2
		move_multiplier = 2
	else:
		strafe_multiplier = 0.5
		move_multiplier = 0.5
	####


func _physics_process(_delta: float) -> void:
	# if the editor is running just exit
	if Engine.is_editor_hint():
		return

	var move_x : float = float(Input.get_action_strength("right")) - float(Input.get_action_strength("left"))
	var move_z : float = float(Input.get_action_strength("backward")) - float(Input.get_action_strength("forward"))

	var direction = (transform.basis * Vector3(move_x, 0, move_z)).normalized()

	velocity.x = direction.x * move_speed * strafe_multiplier
	velocity.z = direction.z * move_speed * move_multiplier

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force
	
	if not is_on_floor():
		velocity.y -= gravity * _delta
	
	move_and_slide()


func _input(event: InputEvent) -> void:
	if mouse_active and event is InputEventMouseMotion:
		# Rotate camera up and down
		camera.rotation.x -= event.relative.y * mouse_sensitivity
		camera.rotation.x = clamp(camera.rotation.x, upDownMinAngle, upDownMaxAngle)
		
		# copy to lights rotation
		wand.rotation.x = camera.rotation.x# - deg_to_rad(90)

		# Rotate player left and right
		rotation.y -= event.relative.x * mouse_sensitivity
		
		# copy y rotate to the input text box
		#camera_rotate_x.text = str(camera.rotation.x)
	
	if mouse_active: # ! FIX to only be set once
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
