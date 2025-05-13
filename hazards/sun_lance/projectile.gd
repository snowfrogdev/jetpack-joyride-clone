extends Area2D

signal player_collision

@onready var sfx: AudioStreamPlayer = $ImpactSfx

func _ready() -> void:
  body_entered.connect(_on_body_entered)

func _on_body_entered(body) -> void:
  if body.is_in_group("player"):
    player_collision.emit()
    sfx.play()
    if body.has_method("zap_player"):
      body.zap_player()
