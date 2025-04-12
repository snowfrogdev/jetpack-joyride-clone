extends GameState

func enter(_prev: String, _data: Dictionary = {}) -> void:
  if OS.has_feature("debug"):
    print("Entering Running state")
  get_tree().paused = false
  game.died.connect(_on_player_died)

func exit() -> void:
  if OS.has_feature("debug"):
    print("Exiting Running state")
  game.died.disconnect(_on_player_died)

func _on_player_died() -> void:
  finished.emit(DYING)
