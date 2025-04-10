extends CharacterBody2D

@export var gravity: float = 800
@export var boost_force: float = 1000.0
@export var max_ascend_speed: float = 200.0
@export var max_fall_speed: float = 600.0
@export var damping: float = 0.3

func _physics_process(delta: float) -> void:
  if not is_on_floor():
    velocity.y += gravity * delta
  
  if Input.is_action_pressed("Boost"):
    if velocity.y > 0:
      velocity.y *= damping
  
    velocity.y -= boost_force * delta
    velocity.y = max(velocity.y, -max_ascend_speed)
  elif velocity.y < 0:
    velocity.y *= damping

  velocity.y = min(velocity.y, max_fall_speed)

  move_and_slide()
