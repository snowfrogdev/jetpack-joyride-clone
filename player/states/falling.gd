extends PlayerState

var sliding_timer: float = 0.0
var is_sliding: bool = false
var fling_speed: float = 300.0 # Speed at which player flings to the right
const SLIDE_DURATION: float = 1.0 # Slide duration in seconds

func enter(_prev: String, _data: Dictionary = {}):
  player.animation_tree.set("parameters/TimeScale/scale", 1.0)
  player.anim_state_machine.travel("FALL")
  # Disable collision with obstacles
  player.set_collision_with_hazards(false)
  # Set horizontal velocity for flinging to the right
  player.velocity.x = fling_speed
  # Disable boosting when falling/dying
  player.boost_disabled = true

func exit() -> void:
  # Reset the sliding timer
  sliding_timer = 0.0
  is_sliding = false

func physics_update(delta: float) -> void:
  if is_sliding:
    # Handle sliding state
    sliding_timer += delta
    # Gradually reduce horizontal velocity during slide
    player.velocity.x = max(player.velocity.x * 0.99, 0)
    if sliding_timer >= SLIDE_DURATION:
      player.velocity.x = 0 # Stop sliding after duration
      finished.emit(DEAD)
  elif player.is_on_floor():
    # Start sliding when player hits the floor
    player.anim_state_machine.travel("SLIDE")
    is_sliding = true