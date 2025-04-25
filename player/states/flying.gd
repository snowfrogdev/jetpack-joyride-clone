extends PlayerState

func enter(_prev: String, _data: Dictionary = {}):
  player.animation_tree.set("parameters/TimeScale/scale", 1.0)
  player.anim_state_machine.travel("RESET")

func physics_update(_delta: float) -> void:
  if player.is_on_floor():
    finished.emit(RUNNING)