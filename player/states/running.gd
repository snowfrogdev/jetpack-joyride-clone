extends PlayerState

func enter(_prev: String, _data: Dictionary = {}):
  player.animation_tree.set("parameters/TimeScale/scale", player.run_animation_speed)
  player.anim_state_machine.travel("RUN")

func physics_update(_delta: float) -> void:
  if not player.is_on_floor():
    finished.emit(FLYING)