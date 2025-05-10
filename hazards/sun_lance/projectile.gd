extends Area2D

@onready var sfx: AudioStreamPlayer = $ImpactSfx

func play_impact_sfx() -> void:
  sfx.play()