@tool
class_name SunCoreRelays extends Node2D

@export var beam_width: float = 16.0

@onready var start_node := $StartNode
@onready var end_node := $EndNode
@onready var beam_path := $Beam
@onready var beam_collider := $Collider
@onready var beam_collision_shape := $Collider/CollisionShape2D

func _ready():
  # Duplicate the shape so it’s unique to this instance
  if beam_collision_shape.shape:
      beam_collision_shape.shape = beam_collision_shape.shape.duplicate()

func _process(_delta):
  if Engine.is_editor_hint():
    center_self()
  
  update_beam_transform()
  update_node_rotations()

func center_self():
  if not (start_node and end_node):
      return

  # Calculate global midpoint
  var global_start = start_node.global_position
  var global_end = end_node.global_position
  var global_center = (global_start + global_end) / 2.0

  # Move this node to that position
  global_position = global_center

  # Update start/end positions relative to the new origin
  start_node.position = global_start - global_center
  end_node.position = global_end - global_center

func update_beam_transform():
  if not (start_node and end_node and beam_path and beam_collision_shape):
      return

  var start_pos = start_node.position
  var end_pos = end_node.position
  var dir = end_pos - start_pos
  var length = dir.length()
  var center = start_pos + dir / 2.0
  var angle = dir.angle()

  # Update collision shape
  assert(beam_collision_shape.shape and beam_collision_shape.shape is RectangleShape2D, "Beam shape is not a RectangleShape2D or is invalid.")
  var shape = beam_collision_shape.shape as RectangleShape2D
  shape.size = Vector2(length + 50, beam_width)
  beam_collision_shape.position = center
  beam_collision_shape.rotation = angle

  # Reset the beam's transform so we can work with local coordinates
  beam_path.scale = Vector2(1, 1) # Reset scale to apply it correctly later
  beam_path.rotation = 0
  beam_path.position = Vector2.ZERO
  
  # Calculate half width for the beam
  var half_width = beam_width / 2.0
  
  # Create a rectangle aligned with the x-axis
  var points = PackedVector2Array([
    Vector2(-length / 2, -half_width), # Top left
    Vector2(length / 2, -half_width), # Top right
    Vector2(length / 2, half_width), # Bottom right
    Vector2(-length / 2, half_width) # Bottom left
  ])
  
  # Set the polygon points
  beam_path.polygon = points
  
  # Position and rotate the beam properly
  beam_path.position = center
  beam_path.rotation = angle
  
  # Re-apply the vertical scale that was in the original scene
  beam_path.scale.y = 10.25
  
  # Update UVs to maintain proper texture mapping
  var uvs = PackedVector2Array([
    Vector2(0, 0), # Top left
    Vector2(1, 0), # Top right
    Vector2(1, 1), # Bottom right
    Vector2(0, 1) # Bottom left
  ])
  beam_path.uv = uvs

func update_node_rotations():
  if not (start_node and end_node):
    return
    
  # Calculate direction vectors
  var beam_direction = end_node.position - start_node.position
  
  # Rotate start node to face toward the end node
  # The -PI/2 offset is to account for the original sprite orientation
  start_node.rotation = beam_direction.angle() - PI / 2
  
  # Rotate end node to face toward the start node (opposite direction)
  # The PI/2 offset is to account for the original sprite orientation
  end_node.rotation = beam_direction.angle() + PI / 2