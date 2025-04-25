extends PlayerState

func enter(_prev: String, _data: Dictionary = {}):
  player.state_machine.travel("REST")