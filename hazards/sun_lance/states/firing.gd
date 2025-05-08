extends SunLanceState

func enter(_previous_state_path: String, _data: Dictionary = {}) -> void:
    print("Entering Firing state")
    sun_lance_attack.tracking_warning_sprite.visible = false
    sun_lance_attack.locked_warning_sprite.visible = true
    
    await get_tree().create_timer(1.0).timeout
    sun_lance_attack.locked_warning_sprite.visible = false
    
    sun_lance_attack.projectile.visible = true
    sun_lance_attack.projectile.position.y = _data["target_y"]
    sun_lance_attack.projectile.global_position.x = sun_lance_attack.global_position.x

    finished.emit(FIRED, _data)