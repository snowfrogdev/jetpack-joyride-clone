extends ParallaxBackground

var speed: float = 0.0

func _process(delta: float) -> void:
    # Move the background based on the speed and delta time
    scroll_offset.x -= speed * delta