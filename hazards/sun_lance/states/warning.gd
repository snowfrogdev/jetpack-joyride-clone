extends SunLanceState

func enter(_previous_state_path: String, _data := {}) -> void:
  print("Entering Warning state")
  sun_lance_attack.warning.position.y = sun_lance_attack.player.position.y
  sun_lance_attack.tracking_warning_sprite.visible = true
  sun_lance_attack.locked_warning_sprite.visible = false

func update(delta: float) -> void:
  var target_y: float = lerp(sun_lance_attack.warning.position.y, sun_lance_attack.player.position.y, clamp(delta * sun_lance_attack.tracking_speed, 0.0, 1.0))
  sun_lance_attack.warning.position.y = target_y
  var attack_trigger_x = sun_lance_attack.trigger_node.get_trailing_edge_x()
  if attack_trigger_x <= sun_lance_attack.detection_line:
    finished.emit(FIRING, {"target_y": target_y})
