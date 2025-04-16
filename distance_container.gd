extends VBoxContainer

@onready var game: Game = %Game
@onready var current_label: Label = $CurrentDistanceLabel
@onready var best_label: Label = $BestDistanceLabel

func _ready() -> void:
    current_label.text = "0000M"
    best_label.text = "BEST: 0000M"
    game.distance_changed.connect(_on_distance_changed)
    game.best_distance_changed.connect(_on_best_distance_changed)
    game.best_distance_surpassed.connect(_on_best_distance_surpassed)
    
    # Update best label immediately with loaded value
    _on_best_distance_changed(game.best_distance)

func _on_distance_changed(distance: int) -> void:
    current_label.text = "%04dM" % distance

func _on_best_distance_changed(best: int) -> void:
    best_label.text = "BEST: %04dM" % best

func _on_best_distance_surpassed() -> void:
    best_label.text = "NEW BEST!"