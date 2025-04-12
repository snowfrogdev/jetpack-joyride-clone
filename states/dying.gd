extends GameState

var death_timer := 1.0

func enter(_prev: String, _data: Dictionary = {}):
  if OS.has_feature("debug"):
    print("Entering Dying state")
  get_tree().paused = true
  death_timer = 1.0

func update(delta: float):
  death_timer -= delta
  if death_timer <= 0:
    if OS.has_feature("debug"):
        print("Exiting Dying state")
    emit_signal("finished", "GameOver")