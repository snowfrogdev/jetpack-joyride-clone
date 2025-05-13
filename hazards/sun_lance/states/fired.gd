extends SunLanceState

func enter(_previous_state_path: String, _data: Dictionary = {}) -> void:
  if OS.has_feature("debug"):
    print("Entering Fired state")
  
  # Connect to the projectile's player_collision signal
  sun_lance_attack.projectile.player_collision.connect(_on_player_collision)
  
  # Queue free after timeout if no collision occurs
  await get_tree().create_timer(15).timeout
  
  # Check if the node still exists before freeing
  if is_instance_valid(sun_lance_attack):
    sun_lance_attack.queue_free()

func exit() -> void:
  # Disconnect the signal when exiting the state to prevent memory leaks
  if is_instance_valid(sun_lance_attack) and is_instance_valid(sun_lance_attack.projectile):
    if sun_lance_attack.projectile.player_collision.is_connected(_on_player_collision):
      sun_lance_attack.projectile.player_collision.disconnect(_on_player_collision)

func physics_update(delta: float) -> void:
  if is_instance_valid(sun_lance_attack) and is_instance_valid(sun_lance_attack.projectile):
    sun_lance_attack.projectile.position.x -= sun_lance_attack.projectile_speed * delta

func _on_player_collision() -> void:
  # free the sun lance attack after a certain time or once the animation is done
  if is_instance_valid(sun_lance_attack):
    # make the sunlance attack invisible and prevent it from colliding with the player
    sun_lance_attack.projectile.visible = false
    sun_lance_attack.projectile.set_collision_mask(0)
    sun_lance_attack.projectile.set_collision_layer(0)