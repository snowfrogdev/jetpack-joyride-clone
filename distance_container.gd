extends VBoxContainer

@onready var game: Game = %Game

func _ready() -> void:
  game.distance_changed.connect(_on_distance_changed)
  $CurrentDistanceLabel.text = "%04dM" % 0

func _on_distance_changed(distance: int) -> void:
  $CurrentDistanceLabel.text = "%04dM" % distance
