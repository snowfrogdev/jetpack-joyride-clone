extends SunLanceState

func enter(_previous_state_path: String, _data: Dictionary = {}) -> void:
    if OS.has_feature("debug"):
        print("Entering Firing state")
    sun_lance_attack.tracking_warning_sprite.visible = false
    sun_lance_attack.locked_warning_sprite.visible = true
    
    # Play warning sound with pitch variation
    var warning_audio = $"../../Warning/AudioStreamPlayer"
    warning_audio.play()
    
    await get_tree().create_timer(1.0).timeout
    sun_lance_attack.locked_warning_sprite.visible = false
    
    sun_lance_attack.projectile.visible = true
    sun_lance_attack.projectile.position.y = _data["target_y"]
    sun_lance_attack.projectile.global_position.x = sun_lance_attack.global_position.x

    # Play the projectile sound effect with random pitch variation
    var audio_player = $"../../Projectile/AudioStreamPlayer"
    # Random pitch between 0.9 and 1.1 for subtle variation
    audio_player.pitch_scale = randf_range(0.9, 1.1)
    audio_player.play(0.1)

    finished.emit(FIRED, _data)