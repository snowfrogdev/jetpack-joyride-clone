extends GameState

func enter(_prev: String, _data: Dictionary = {}) -> void:
  if OS.has_feature("debug"):
    print("Entering Dying state")
  game.died.connect(_on_player_dead)
  game.set_speed(0)

func exit() -> void:
  if OS.has_feature("debug"):
    print("Exiting Dying state")
  game.died.disconnect(_on_player_dead)

func _on_player_dead() -> void:
  finished.emit(GAMEOVER)