extends PlayerState


func enter(_prev: String, _data: Dictionary = {}):
  player.died.emit()