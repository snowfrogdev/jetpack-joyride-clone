extends GameState

@onready var restart_label = get_node("/root/Main/UI/RestartPromptLabel")

func enter(_prev: String, _data: Dictionary = {}) -> void:
  if OS.has_feature("debug"):
    print("Entering GameOver state")
  
  # Don't pause the entire tree, instead just pause gameplay elements
  # This allows audio to continue and input events to be processed
  game.set_speed(0) # Stop the game's scrolling
  
  # Show the restart label
  restart_label.visible = true
  
  # Save best distance
  game.save_best_distance()

func exit() -> void:
  # Hide the restart label when exiting the state
  restart_label.visible = false

func handle_input(event: InputEvent) -> void:
  if event.is_action_pressed("ui_accept") or (event is InputEventMouseButton and event.pressed and event.button_index == 1):
    if OS.has_feature("debug"):
      print("Exiting GameOver state")
    get_tree().reload_current_scene()