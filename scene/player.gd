extends CharacterBody3D

@onready var camera: Camera3D = $mesh/camera
@onready var player: CharacterBody3D = $"."

@onready var mouse_speed_le: LineEdit = $"Control/VBoxContainer/HBoxContainer/mouse speed"
@onready var mouse_speed_sl: HSlider = $"Control/VBoxContainer/HBoxContainer2/mouse speed"


# globals for mouse control
var mouse_sensitivity = 0.004
var upDownMinAngle = -90.0
var upDownMaxAngle = 90.0

var mouse_active = false # handled by right mouse button

var strafe_speed = 2 		# units per second
var strafe_multiplier = 0.5 # increased on boost
var move_speed = 2 			# units per second
var move_multiplier = 0.5 	# increased on boost

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
	velocity.y = 0
	
	move_and_slide()


func _input(event: InputEvent) -> void:
	if mouse_active and event is InputEventMouseMotion:
		# Rotate camera up and down
		camera.rotation.x -= event.relative.y * mouse_sensitivity
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(upDownMinAngle), deg_to_rad(upDownMaxAngle))

		# Rotate player left and right
		rotation.y -= event.relative.x * mouse_sensitivity


func _on_mouse_speed_value_changed(value: float) -> void:
	mouse_speed_le.text = str(value)
	mouse_sensitivity = value


func _on_mouse_speed_down_pressed() -> void:
	if mouse_speed_sl.value > mouse_speed_sl.min_value:
		mouse_speed_sl.value -= mouse_speed_sl.step


func _on_mouse_speed_up_pressed() -> void:
	if mouse_speed_sl.value < mouse_speed_sl.max_value:
		mouse_speed_sl.value += mouse_speed_sl.step
