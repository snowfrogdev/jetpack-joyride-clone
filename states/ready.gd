extends GameState

@onready var intro_music = get_node("/root/Main/IntroMusic")
@onready var game_music = get_node("/root/Main/Music")

func enter(_prev: String, _data: Dictionary = {}) -> void:
  if OS.has_feature("debug"):
    print("Entering Ready state")
  
  game.load_best_distance()
  get_tree().paused = true
  
  # Show the game title and boost prompt labels
  get_node("/root/Main/UI/GameTitleLabel").visible = true
  get_node("/root/Main/UI/BoostPromptLabel").visible = true
  
  # Stop game music if it's playing and play intro music
  game_music.stop()
  intro_music.play()

func update(_delta) -> void:
  if Input.is_action_just_pressed("Boost"):
    if OS.has_feature("debug"):
      print("Exiting Ready state")
    
    # Hide the game title and boost prompt labels
    get_node("/root/Main/UI/GameTitleLabel").visible = false
    get_node("/root/Main/UI/BoostPromptLabel").visible = false
    
    emit_signal("finished", "Running")
