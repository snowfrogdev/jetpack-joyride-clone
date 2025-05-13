extends GameState

@onready var intro_music = get_node("/root/Main/IntroMusic")
@onready var game_music = get_node("/root/Main/Music")
@export var crossfade_duration: float = 1.0

var transition_timer: float = 0.0
var transitioning: bool = false
var initial_intro_volume: float
var initial_game_volume: float

func enter(_prev: String, _data: Dictionary = {}) -> void:
  if OS.has_feature("debug"):
    print("Entering Running state")
  get_tree().paused = false
  game.dying.connect(_on_player_dying)
  
  # Start music transition
  initial_intro_volume = intro_music.volume_db
  initial_game_volume = game_music.volume_db
  
  # Start with game music at very low volume
  game_music.volume_db = -80.0
  game_music.play()
  
  transitioning = true
  transition_timer = 0.0

func exit() -> void:
  if OS.has_feature("debug"):
    print("Exiting Running state")
  game.dying.disconnect(_on_player_dying)

func update(delta: float) -> void:
  if transitioning:
    transition_timer += delta
    var t = min(transition_timer / crossfade_duration, 1.0)
    
    # Exponential fade for smoother transition
    var fade_out_value = lerp(initial_intro_volume, -80.0, t * t)
    var fade_in_value = lerp(-80.0, initial_game_volume, t * t)
    
    intro_music.volume_db = fade_out_value
    game_music.volume_db = fade_in_value
    
    if t >= 1.0:
      transitioning = false
      intro_music.stop()
      intro_music.volume_db = initial_intro_volume

func _on_player_dying() -> void:
  finished.emit(DYING)
