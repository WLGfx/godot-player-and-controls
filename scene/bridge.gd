extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for node in get_children():
		if node is MeshInstance3D:
			node.create_trimesh_collision()
	# Oh, that was too easy

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
