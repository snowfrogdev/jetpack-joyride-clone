extends PlayerState

func enter(_prev: String, _data: Dictionary = {}):
  player.animation_tree.set("parameters/TimeScale/scale", player.run_animation_speed)
  player.anim_state_machine.travel("RUN")

  player.footstep_sfx.play()

  player.dying.connect(_on_player_dying)

func exit() -> void:
  player.footstep_sfx.stop()

  player.dying.disconnect(_on_player_dying)

func physics_update(_delta: float) -> void:
  player.footstep_sfx.pitch_scale = 1.5 + sin(Time.get_ticks_msec() / 500.0) * 0.1

  if not player.is_on_floor():
    finished.emit(FLYING)

func _on_player_dying() -> void:
  finished.emit(FALLING)