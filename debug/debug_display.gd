extends Control
class_name DebugDisplay

@export var segment_manager_path: NodePath
@export var font_color: Color = Color.WHITE
@export var background_color: Color = Color(0, 0, 0, 0.5)
@export var margin: Vector2 = Vector2(10, 10) # Margin from bottom-left corner
@export var font_size: int = 16

var segment_manager: SegmentManager
var enabled: bool = true
var debug_panel: PanelContainer
var debug_vbox: VBoxContainer
var info_labels = {}
var update_timer: float = 0
var update_interval: float = 0.1 # Update display every 0.1 seconds to reduce flickering

func _ready() -> void:
  if OS.is_debug_build() or Engine.is_editor_hint():
    if segment_manager_path:
      segment_manager = get_node(segment_manager_path)
    else:
      # Try to find segment manager automatically
      segment_manager = find_segment_manager()
    
    if not segment_manager:
      printerr("DebugDisplay: SegmentManager not found!")
    
    # Create persistent UI elements
    _setup_debug_ui()
  else:
    # Hide debug display in release builds
    enabled = false
    visible = false

func _setup_debug_ui() -> void:
  # Create panel container for background
  debug_panel = PanelContainer.new()
  debug_panel.add_theme_stylebox_override("panel", StyleBoxFlat.new())
  var panel_style = debug_panel.get_theme_stylebox("panel") as StyleBoxFlat
  panel_style.bg_color = background_color
  panel_style.corner_radius_top_left = 4
  panel_style.corner_radius_top_right = 4
  panel_style.corner_radius_bottom_left = 4
  panel_style.corner_radius_bottom_right = 4
  
  # Add VBox container for text
  debug_vbox = VBoxContainer.new()
  debug_vbox.add_theme_constant_override("separation", 0)
  debug_panel.add_child(debug_vbox)
  
  # Add title label
  var title_label = Label.new()
  title_label.text = "DEBUG: SEGMENT INFO"
  title_label.add_theme_color_override("font_color", font_color)
  title_label.add_theme_font_size_override("font_size", font_size)
  debug_vbox.add_child(title_label)
  
  # Position at bottom left with margins
  add_child(debug_panel)
  
  # Size and position will be updated in _process
  debug_panel.size_flags_horizontal = Control.SIZE_SHRINK_END
  debug_panel.size_flags_vertical = Control.SIZE_SHRINK_END

func _process(delta: float) -> void:
  # Only update when enabled and in debug mode
  if not enabled or (not OS.is_debug_build() and not Engine.is_editor_hint()):
    return
  
  # Throttle updates to reduce flickering
  update_timer += delta
  if update_timer >= update_interval:
    update_timer = 0
    _update_debug_info()
  
  # Always ensure proper positioning at bottom left
  if debug_panel:
    var viewport_size = get_viewport_rect().size
    debug_panel.position = Vector2(margin.x, viewport_size.y - debug_panel.size.y - margin.y)

func _update_debug_info() -> void:
  if not segment_manager or not debug_vbox:
    return
    
  var segments_info = segment_manager.get_segments_in_viewport()
  
  # Remove labels for segments that are no longer visible
  var existing_indices = info_labels.keys()
  for idx in existing_indices:
    if idx >= segments_info.size():
      info_labels[idx].queue_free()
      info_labels.erase(idx)
  
  # Update or create labels for visible segments
  for i in range(segments_info.size()):
    var info = segments_info[i]
    var name_str = info.name
    var difficulty_str = "%.1f" % info.difficulty
    var info_text = "Name: %s | Difficulty: %s" % [name_str, difficulty_str]
    
    if not info_labels.has(i):
      # Create new label if needed
      var label = Label.new()
      label.add_theme_color_override("font_color", font_color)
      label.add_theme_font_size_override("font_size", font_size)
      debug_vbox.add_child(label)
      info_labels[i] = label
    
    # Update label text
    info_labels[i].text = info_text

# Try to find segment manager in the scene
func find_segment_manager() -> SegmentManager:
  var seg_managers = get_tree().get_nodes_in_group("segment_manager")
  if not seg_managers.is_empty():
    return seg_managers[0]
  
  # Second attempt - find by class
  var nodes = get_tree().get_nodes_in_group("SegmentManager")
  for node in nodes:
    if node is SegmentManager:
      return node
  
  # Last attempt - brute force search
  return find_node_by_class("SegmentManager")

# Recursively search for a node of specific class type
func find_node_by_class(cls_name: String) -> Node:
  var root = get_tree().root
  return _find_node_by_class_recursive(root, cls_name)

func _find_node_by_class_recursive(node: Node, cls_name: String) -> Node:
  if node.get_class() == cls_name:
    return node
  
  for child in node.get_children():
    var found = _find_node_by_class_recursive(child, cls_name)
    if found:
      return found
      
  return null