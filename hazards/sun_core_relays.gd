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
    beam_path.width = beam_width
    center_self()
  
  update_beam_transform()

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

  # Check if the shape is valid before modifying it
  assert(beam_collision_shape.shape and beam_collision_shape.shape is RectangleShape2D, "Beam shape is not a RectangleShape2D or is invalid.")
  var shape = beam_collision_shape.shape as RectangleShape2D
  shape.size = Vector2(length, beam_width) # Use the editable beam width
  beam_collision_shape.position = center
  beam_collision_shape.rotation = angle

  # Update the beam line points
  beam_path.clear_points()
  beam_path.add_point(start_node.position)
  beam_path.add_point(end_node.position)