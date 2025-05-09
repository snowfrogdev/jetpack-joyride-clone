@icon("res://icon.svg")
class_name SegmentData extends Resource

@export var segment_scene: PackedScene
@export_range(0.0, 1, 0.1) var difficulty: float = 0.0

# Returns the name of the segment from the scene resource
func get_segment_name() -> String:
    if segment_scene:
        var scene_path = segment_scene.resource_path
        if scene_path:
            # Extract the filename without extension
            var filename = scene_path.get_file().get_basename()
            return filename
    return "Unknown Segment"