extends ParallaxBackground

@export var speed: float = 100.0

func _process(delta: float) -> void:
    # Move the background based on the speed and delta time
    scroll_offset.x -= speed * delta