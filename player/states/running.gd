extends PlayerState

func enter(_prev: String, _data: Dictionary = {}):
  player.animation_tree.set("parameters/TimeScale/scale", player.run_animation_speed)
  player.anim_state_machine.travel("RUN")
  player.dying.connect(_on_player_dying)

func exit() -> void:
  player.dying.disconnect(_on_player_dying)

func physics_update(_delta: float) -> void:
  if not player.is_on_floor():
    finished.emit(FLYING)

func _on_player_dying() -> void:
  finished.emit(FALLING)