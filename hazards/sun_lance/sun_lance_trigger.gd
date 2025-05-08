class_name SunLanceTrigger extends Area2D


@onready var collision_shape: CollisionShape2D = get_node("CollisionShape2D")

func get_trailing_edge_x() -> float:
    var extents = collision_shape.shape.extents.x
    # Account for the CollisionShape2D's position relative to the Area2D
    var shape_position_offset = collision_shape.position.x
    # Calculate the rightmost edge in global coordinates
    return global_position.x + shape_position_offset + extents