class_name Game extends Node2D

signal died

@export var speed: float = 100.0

func _ready() -> void:
  $Player.died.connect(_on_player_died)
  set_speed(speed)

func _on_player_died() -> void:
  died.emit()

func set_speed(new_speed: float) -> void:
  speed = new_speed
  $ParallaxBackground.speed = speed
  $SegmentManager.scroll_speed = speed

func _set(property: StringName, value) -> bool:
  if property == "speed":
    set_speed(value)
    return true
  return false