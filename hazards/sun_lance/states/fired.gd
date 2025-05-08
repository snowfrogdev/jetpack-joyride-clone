extends SunLanceState

func enter(_previous_state_path: String, _data: Dictionary = {}) -> void:
  print("Entering Fired state")
  await get_tree().create_timer(15).timeout
  sun_lance_attack.queue_free()

func physics_update(delta: float) -> void:
  sun_lance_attack.projectile.position.x -= sun_lance_attack.projectile_speed * delta