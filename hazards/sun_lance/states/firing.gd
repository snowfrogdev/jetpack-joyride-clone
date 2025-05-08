extends SunLanceState

func enter(_previous_state_path: String, _data: Dictionary = {}) -> void:
    print("Entering Firing state")
    sun_lance_attack.tracking_warning_sprite.visible = false
    sun_lance_attack.locked_warning_sprite.visible = true
    # wait one second before firing
    await get_tree().create_timer(1.0).timeout
    print("Firing at y:", _data["target_y"])
    finished.emit(FIRED)