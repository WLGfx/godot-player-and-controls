extends Node3D

@onready var ceiling: Node3D = $Ceiling

var first_mesh: MeshInstance3D
var material: Material
var emmision_strength: float = 0.2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for node in get_children():
		if node is MeshInstance3D:
			node.create_trimesh_collision()
			# set the first mesh if it's a meshinstance3d
			if first_mesh == null:
				first_mesh = node
				print("Found first mesh")
				# and set the material
				material = first_mesh.get_active_material(0)
				print(material)
	# Oh, that was too easy
	for node in ceiling.get_children():
		if node is MeshInstance3D:
			node.create_trimesh_collision()
	# and that just fixes the ceiling
	
	# now grab the material from a meshinstance3d


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if material is BaseMaterial3D:
		var sine_position: float = sin(0.003 * Time.get_ticks_msec())
		material.emission_energy_multiplier = emmision_strength + sine_position * 0.2
