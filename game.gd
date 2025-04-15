class_name Game extends Node2D

signal died
signal distance_changed(distance: int)

var current_distance := 0
var distance_accumulator := 0.0
@export var pixels_per_meter := 100.0
@export var speed: float = 100.0

func _ready() -> void:
  $Player.died.connect(_on_player_died)
  set_speed(speed)

func _process(delta: float) -> void:
  if speed > 0:
    var delta_distance = speed * delta / pixels_per_meter
    distance_accumulator += delta_distance
    if distance_accumulator >= 1.0:
      var whole_meters = int(distance_accumulator)
      distance_accumulator -= whole_meters
      current_distance += whole_meters
      distance_changed.emit(current_distance)

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