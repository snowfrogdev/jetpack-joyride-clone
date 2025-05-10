extends Node2D
class_name SegmentManager

@export var segments: Array[SegmentData]
@export var initial_segments: Array[SegmentData] = []
@export var viewport_width: float = 1280.0
@export var spawn_buffer: float = 200.0
@export var max_active_segments: int = 5
@export var debug_mode: bool = false
@export var current_difficulty: float = 0.0 # current game difficulty (0-1)
@export var curve_factor: float = 2.0 # higher = narrower selection

var scroll_speed: float = 0.0
var _active_segments: Array[Node2D] = []
var _active_segment_data: Array[SegmentData] = []
var _last_segment_end_x: float
var _initial_segments_queue: Array[SegmentData] = []

func _ready():
  add_to_group("segment_manager")
  _initial_segments_queue = initial_segments.duplicate()
  spawn_initial_segments()
  
  # Connect to game's difficulty changed signal if available
  var game = get_parent()
  if game is Game:
    game.difficulty_changed.connect(_on_difficulty_changed)
    if debug_mode:
      print("SegmentManager connected to Game difficulty signal")

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
  _last_segment_end_x = get_viewport_right_edge() + spawn_buffer
  spawn_next_segment()

func spawn_next_segment():
  assert(segments.size() > 0, "No segments available to spawn.")

  var segment_data: SegmentData
  if _initial_segments_queue.size() > 0:
    segment_data = _initial_segments_queue.pop_front()
  else:
    segment_data = pick_weighted_segment()
    
  var segment_instance = segment_data.segment_scene.instantiate() as Node2D

  segment_instance.position = Vector2(_last_segment_end_x, 0.0)
  add_child(segment_instance)
  _active_segments.append(segment_instance)
  _active_segment_data.append(segment_data)

  _last_segment_end_x += get_segment_length(segment_instance)

func pick_weighted_segment() -> SegmentData:
  var total_weight := 0.0
  var weights := []

  for seg in segments:
    var diff_delta: float = abs(seg.difficulty - current_difficulty)
    var weight := pow(1.0 - diff_delta, curve_factor)
    weight = max(weight, 0.001) # ensure nonzero
    weights.append(weight)
    total_weight += weight

  var rand := randf() * total_weight
  var accum := 0.0

  for i in range(segments.size()):
    accum += weights[i]
    if rand <= accum:
      return segments[i]

  return segments[-1] # fallback

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
      _active_segment_data.pop_front()
    else:
      break

func get_segments_in_viewport() -> Array:
  var viewport_left = get_viewport_left_edge()
  var viewport_right = get_viewport_right_edge()
  var segments_info = []
  
  for i in range(_active_segments.size()):
    var segment = _active_segments[i]
    var data = _active_segment_data[i]
    var segment_left = segment.position.x
    var segment_right = segment_left + get_segment_length(segment)
    
    if segment_right > viewport_left and segment_left < viewport_right:
      var percent_visible = calculate_percent_visible(segment_left, segment_right, viewport_left, viewport_right)
      segments_info.append({
        "name": data.get_segment_name(),
        "difficulty": data.difficulty,
        "percent_visible": percent_visible,
        "position": segment.position
      })
  
  return segments_info

func calculate_percent_visible(segment_left: float, segment_right: float, viewport_left: float, viewport_right: float) -> float:
  var segment_length = segment_right - segment_left
  var overlap_left = max(segment_left, viewport_left)
  var overlap_right = min(segment_right, viewport_right)
  var overlap_length = max(0, overlap_right - overlap_left)
  return overlap_length / segment_length * 100.0

func get_segment_resource_name(index: int) -> String:
  var resource_path = _active_segment_data[index].resource_path
  if resource_path:
    var file_name = resource_path.get_file().get_basename()
    return file_name
  return "Segment " + str(index)

func _on_difficulty_changed(new_difficulty: float):
  current_difficulty = new_difficulty
  if debug_mode:
    print("SegmentManager difficulty updated to: ", current_difficulty)
