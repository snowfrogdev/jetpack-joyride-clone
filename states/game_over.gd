extends GameState

func enter(_prev: String, _data: Dictionary = {}) -> void:
  if OS.has_feature("debug"):
    print("Entering GameOver state")
  
  game.save_best_distance()

func handle_input(event: InputEvent) -> void:
  if event.is_action_pressed("ui_accept"):
    if OS.has_feature("debug"):
      print("Exiting GameOver state")
    get_tree().reload_current_scene()