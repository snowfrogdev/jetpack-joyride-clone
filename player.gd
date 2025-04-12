class_name Player extends CharacterBody2D

@export var gravity: float = 800
@export var boost_force: float = 1000.0
@export var max_ascend_speed: float = 200.0
@export var max_fall_speed: float = 600.0
@export var damping: float = 0.3

signal died

@onready var hurtbox: Area2D = $Hurtbox

func _ready() -> void:
  hurtbox.area_entered.connect(_on_hurtbox_area_entered)

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

func _on_hurtbox_area_entered(area: Area2D) -> void:
  var current = area
  while current:
    if current.is_in_group("hazard"):
        died.emit()
        break
    current = current.get_parent()