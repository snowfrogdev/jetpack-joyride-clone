extends SunLanceState

func enter(_previous_state_path: String, _data: Dictionary = {}) -> void:
  print("Entering Fired state")
  await get_tree().create_timer(5).timeout
  sun_lance_attack.queue_free()