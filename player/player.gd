class_name Player extends CharacterBody2D

@export var gravity: float = 800
@export var boost_force: float = 1000.0
@export var max_ascend_speed: float = 200.0
@export var max_fall_speed: float = 600.0
@export var damping: float = 0.3
var run_animation_speed: float = 1.0
var boost_disabled: bool = false

signal dying
signal died

@onready var hurtbox: Area2D = $Hurtbox
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var boosters_sfx: AudioStreamPlayer = $BoostersSfx
@onready var applied_boosters_sfx: AudioStreamPlayer = $AppliedBoostersSfx
@onready var footstep_sfx: AudioStreamPlayer = $FootstepsSfx
var anim_state_machine: AnimationNodeStateMachinePlayback
var ignore_hazards: bool = false

func _ready() -> void:
  hurtbox.area_entered.connect(_on_hurtbox_area_entered)
  anim_state_machine = animation_tree["parameters/StateMachine/playback"]

func _physics_process(delta: float) -> void:
  if not is_on_floor():
    velocity.y += gravity * delta

  if not Input.is_action_just_pressed("Boost"):
    if applied_boosters_sfx.is_playing():
      applied_boosters_sfx.stop()
  
  if Input.is_action_pressed("Boost") and not boost_disabled:
    if velocity.y > 0:
      velocity.y *= damping
  
    velocity.y -= boost_force * delta
    velocity.y = max(velocity.y, -max_ascend_speed)

    if not applied_boosters_sfx.is_playing():
      applied_boosters_sfx.pitch_scale = randf_range(1.2, 1.5)
      applied_boosters_sfx.play()

  elif velocity.y < 0:
    velocity.y *= damping

  velocity.y = min(velocity.y, max_fall_speed)

  move_and_slide()

func _on_hurtbox_area_entered(area: Area2D) -> void:
  # If we're ignoring hazards, don't process collisions
  if ignore_hazards:
    return
    
  var current = area
  while current:
    if current.is_in_group("hazard"):
      current.play_impact_sfx()
      dying.emit()
      break
    current = current.get_parent()
    
func set_run_animation_speed(speed: float) -> void:
  run_animation_speed = speed / 100.0
  
func set_collision_with_hazards(enabled: bool) -> void:
  # When enabled is false, we ignore hazards
  ignore_hazards = !enabled