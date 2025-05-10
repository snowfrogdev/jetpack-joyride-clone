class_name Game
extends Node2D

signal died
signal dying
signal distance_changed(distance: int)
signal best_distance_changed(distance: int)
signal best_distance_surpassed() # New: emitted mid-run once
signal difficulty_changed(difficulty: float) # New: emitted when difficulty changes

var current_distance := 0
var distance_accumulator := 0.0
var best_distance := 0
var has_surpassed_best := false # Tracks mid-run surpass
var current_difficulty := 0.0 # Tracks current difficulty level (0.0-1.0)
var _last_difficulty := 0.0 # Used to prevent emitting redundant signals

@export var pixels_per_meter := 100.0
@export var speed: float = 100.0
@export var max_difficulty_distance := 2000.0 # Distance at which max difficulty is reached


func _ready() -> void:
  # Add the game to a group for easy reference
  add_to_group("game")
  
  $Player.died.connect(_on_player_died)
  $Player.dying.connect(_on_player_dying)
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

            # Emit once when player surpasses previous best
            if not has_surpassed_best and current_distance > best_distance:
                has_surpassed_best = true
                best_distance_surpassed.emit()
                
            # Update game difficulty based on distance
            update_difficulty()

func _on_player_died() -> void:
    died.emit()

func _on_player_dying() -> void:
    dying.emit()

func set_speed(new_speed: float) -> void:
    speed = new_speed
    $ParallaxBackground.speed = speed
    $SegmentManager.scroll_speed = speed
    $Player.set_run_animation_speed(speed)

func _set(property: StringName, value) -> bool:
    if property == "speed":
        set_speed(value)
        return true
    return false

func save_best_distance() -> void:
    if current_distance > best_distance:
        best_distance = current_distance
        var data = {"best_distance": best_distance}
        var file = FileAccess.open("user://best_distance.json", FileAccess.WRITE)
        file.store_string(JSON.stringify(data))
        best_distance_changed.emit(best_distance)
        if OS.has_feature("debug"):
          print("Best distance saved:", best_distance) # Logging added

func load_best_distance() -> void:
    if FileAccess.file_exists("user://best_distance.json"):
        var file = FileAccess.open("user://best_distance.json", FileAccess.READ)
        var json = JSON.parse_string(file.get_as_text())
        if typeof(json) == TYPE_DICTIONARY and json.has("best_distance"):
            best_distance = json["best_distance"]
            best_distance_changed.emit(best_distance)
            if OS.has_feature("debug"):
              print("Best distance loaded:", best_distance) # Logging added

func update_difficulty() -> void:
    # Calculate new difficulty based on distance (0.0 to 1.0)
    var new_difficulty = clamp(current_distance / max_difficulty_distance, 0.0, 1.0)
    
    # Only emit signal if difficulty actually changed (to avoid spam)
    if new_difficulty != _last_difficulty:
        current_difficulty = new_difficulty
        _last_difficulty = new_difficulty
        difficulty_changed.emit(current_difficulty)

func reset_run_state() -> void:
    current_distance = 0
    distance_accumulator = 0.0
    has_surpassed_best = false
    current_difficulty = 0.0
    _last_difficulty = 0.0
