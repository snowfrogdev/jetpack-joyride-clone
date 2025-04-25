extends PlayerState

func enter(_prev: String, _data: Dictionary = {}):
  player.animation_player.play("REST")