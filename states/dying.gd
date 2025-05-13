extends GameState

@onready var game_music = get_node("/root/Main/Music")
@onready var game_over_jingle = get_node("/root/Main/GameOverJingle")

func enter(_prev: String, _data: Dictionary = {}) -> void:
  if OS.has_feature("debug"):
    print("Entering Dying state")
  game.died.connect(_on_player_dead)
  game.set_speed(0)
  
  # Stop the game music before playing the game over jingle
  game_music.stop()
  
  # Play the game over jingle
  if game_over_jingle:
    game_over_jingle.play()

func exit() -> void:
  if OS.has_feature("debug"):
    print("Exiting Dying state")
  game.died.disconnect(_on_player_dead)

func _on_player_dead() -> void:
  finished.emit(GAMEOVER)