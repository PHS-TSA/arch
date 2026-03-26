extends NavigationRegion3D

@export_range(0.1, 1.0, 0.05) var agent_radius: float = 0.25
@export_range(0.5, 3.0, 0.1) var agent_height: float = 1.5
@export_range(0.0, 2.0, 0.05) var agent_max_climb: float = 0.5
@export_range(1.0, 90.0, 1.0) var agent_max_slope: float = 45.0
@export_range(0.05, 1.0, 0.05) var cell_size: float = 0.25
@export_range(0.05, 1.0, 0.05) var cell_height: float = 0.25


func _ready() -> void:
	var baked_navigation_mesh := navigation_mesh
	if baked_navigation_mesh == null:
		baked_navigation_mesh = NavigationMesh.new()
		navigation_mesh = baked_navigation_mesh

	baked_navigation_mesh.clear()
	baked_navigation_mesh.cell_size = cell_size
	baked_navigation_mesh.cell_height = cell_height
	baked_navigation_mesh.agent_radius = agent_radius
	baked_navigation_mesh.agent_height = agent_height
	baked_navigation_mesh.agent_max_climb = agent_max_climb
	baked_navigation_mesh.agent_max_slope = agent_max_slope
	baked_navigation_mesh.set_parsed_geometry_type(NavigationMesh.PARSED_GEOMETRY_STATIC_COLLIDERS)
	baked_navigation_mesh.set_source_geometry_mode(NavigationMesh.SOURCE_GEOMETRY_ROOT_NODE_CHILDREN)
	baked_navigation_mesh.region_min_size = 0.0
	baked_navigation_mesh.region_merge_size = 0.0

	call_deferred("_bake_region_navigation")


func _bake_region_navigation() -> void:
	bake_navigation_mesh(false)
