extends CharacterBody3D

@onready var camera: Camera3D = $camera
@onready var player: CharacterBody3D = $"."
@onready var wand: MeshInstance3D = $wand

@onready var mouse_speed_le: LineEdit = $"Control/VBoxContainer/HBoxContainer/mouse speed"
@onready var mouse_speed_sl: HSlider = $"Control/VBoxContainer/HBoxContainer2/mouse speed"
@onready var camera_rotate_x: LineEdit = $"Control/VBoxContainer/HBoxContainer3/camera rotate x"


# globals for mouse control
var mouse_sensitivity = 0.004
var upDownMinAngle = -1.1
var upDownMaxAngle = 1.57

var mouse_active = false # handled by right mouse button

var strafe_speed = 2 		# units per second
var strafe_multiplier = 0.5 # increased on boost
var move_speed = 2 			# units per second
var move_multiplier = 0.5 	# increased on boost

var gravity = 9.8			# units per second per second
var jump_force = 5			# units per second

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mouse_speed_le.text = str(mouse_sensitivity)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	mouse_active = Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT)
	
	if Input.is_action_pressed("move boost"):
		strafe_multiplier = 2
		move_multiplier = 2
	else:
		strafe_multiplier = 0.5
		move_multiplier = 0.5
	####


func _physics_process(_delta: float) -> void:
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
		wand.rotation.x = camera.rotation.x - deg_to_rad(90)

		# Rotate player left and right
		rotation.y -= event.relative.x * mouse_sensitivity
		
		# copy y rotate to the input text box
		camera_rotate_x.text = str(camera.rotation.x)
	
	if mouse_active: # ! FIX to only be set once
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_mouse_speed_value_changed(value: float) -> void:
	mouse_speed_le.text = str(value)
	mouse_sensitivity = value


func _on_mouse_speed_down_pressed() -> void:
	if mouse_speed_sl.value > mouse_speed_sl.min_value:
		mouse_speed_sl.value -= mouse_speed_sl.step


func _on_mouse_speed_up_pressed() -> void:
	if mouse_speed_sl.value < mouse_speed_sl.max_value:
		mouse_speed_sl.value += mouse_speed_sl.step
