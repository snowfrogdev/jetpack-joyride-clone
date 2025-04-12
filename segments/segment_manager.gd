extends Node2D
class_name SegmentManager

@export var segments: Array[SegmentData]
@export var viewport_width: float = 1280.0
@export var spawn_buffer: float = 200.0
@export var max_active_segments: int = 5

var scroll_speed: float = 0.0
var _active_segments: Array[Node2D] = []
var _last_segment_end_x: float = 0.0

func _ready():
  spawn_initial_segments()

func _process(delta: float):
  scroll_segments(delta)
  if _last_segment_end_x < get_viewport_right_edge() + spawn_buffer:
    spawn_next_segment()
  
  cleanup_old_segments()

func scroll_segments(delta: float):
  var offset = scroll_speed * delta
  for segment in _active_segments:
    segment.position.x -= offset
  
  _last_segment_end_x -= offset

func get_viewport_right_edge() -> float:
  return viewport_width

func get_viewport_left_edge() -> float:
  return 0.0

func spawn_initial_segments():
  while _last_segment_end_x < get_viewport_right_edge() + spawn_buffer:
    spawn_next_segment()

func spawn_next_segment():
  assert(segments.size() > 0, "No segments available to spawn.")

  var segment_data: SegmentData = segments.pick_random()
  var segment_instance = segment_data.segment_scene.instantiate() as Node2D

  segment_instance.position = Vector2(_last_segment_end_x, 0.0)
  add_child(segment_instance)
  _active_segments.append(segment_instance)

  _last_segment_end_x += get_segment_length(segment_instance)

func get_segment_length(segment: Node2D) -> float:
  var end_marker = segment.get_node_or_null("EndMarker")
  assert(end_marker, "EndMarker node not found in segment.")
  return end_marker.position.x

func cleanup_old_segments():
  while _active_segments.size() > 0:
    var first = _active_segments[0]
    var right_edge = first.global_position.x + get_segment_length(first)
    if right_edge < get_viewport_left_edge() - spawn_buffer:
      first.queue_free()
      _active_segments.pop_front()
    else:
      break
