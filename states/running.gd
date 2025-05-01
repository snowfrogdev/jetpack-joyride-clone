extends GameState

func enter(_prev: String, _data: Dictionary = {}) -> void:
  if OS.has_feature("debug"):
    print("Entering Running state")
  get_tree().paused = false
  game.dying.connect(_on_player_dying)

func exit() -> void:
  if OS.has_feature("debug"):
    print("Exiting Running state")
  game.dying.disconnect(_on_player_dying)

func _on_player_dying() -> void:
  finished.emit(DYING)
