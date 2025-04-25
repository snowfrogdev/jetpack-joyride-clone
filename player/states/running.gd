extends PlayerState

func enter(_prev: String, _data: Dictionary = {}):
  player.animation_player.play("RUN", player.running_animation_speed)