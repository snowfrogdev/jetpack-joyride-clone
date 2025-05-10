extends Area2D

var sun_lance_attack_scene: PackedScene = preload("res://hazards/sun_lance/sun_lance_attack.tscn")

func _ready() -> void:
  connect("area_entered", _on_area_entered)

func _on_area_entered(area: Area2D) -> void:
    if area is SunLanceTrigger:
        var detection_x = _get_detection_line_x()
        call_deferred("_spawn_attack", area, detection_x)

func _spawn_attack(area: Area2D, detection_x: float) -> void:
    var attack = sun_lance_attack_scene.instantiate()
    attack.position = global_position
    attack.init(area, detection_x)
    get_parent().add_child(attack)

func _get_detection_line_x() -> float:
    var shape_node := get_node("CollisionShape2D") as CollisionShape2D
    var shape := shape_node.shape as RectangleShape2D
    return global_position.x + shape_node.position.x + shape.extents.x