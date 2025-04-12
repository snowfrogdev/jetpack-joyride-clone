extends GameState

func enter(_prev: String, _data: Dictionary = {}) -> void:
  if OS.has_feature("debug"):
    print("Entering Ready state")
  get_tree().paused = true

func update(_delta) -> void:
  if Input.is_action_just_pressed("Boost"):
    if OS.has_feature("debug"):
      print("Exiting Ready state")
    emit_signal("finished", "Running")
