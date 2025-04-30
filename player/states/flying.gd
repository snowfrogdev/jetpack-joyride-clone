extends PlayerState

var left_foot_particles: GPUParticles2D
var right_foot_particles: GPUParticles2D

func _init_particles():
  if left_foot_particles == null or right_foot_particles == null:
    left_foot_particles = player.get_node("Skeleton2D/Torso/LegL/ShinL/FootL/GPUParticles2D")
    right_foot_particles = player.get_node("Skeleton2D/Torso/LegR/ShinR/FootR/GPUParticles2D")

func enter(_prev: String, _data: Dictionary = {}):
  player.animation_tree.set("parameters/TimeScale/scale", 1.0)
  player.anim_state_machine.travel("FLY")
  
  # Initialize particles when we know player is ready
  _init_particles()
  
  # Start emitting particles
  left_foot_particles.emitting = true
  right_foot_particles.emitting = true
  
  # Make sure particles are visible
  left_foot_particles.visible = true
  right_foot_particles.visible = true

func physics_update(_delta: float) -> void:
  if player.is_on_floor():
    finished.emit(RUNNING)

func exit() -> void:
  # Stop emitting particles
  left_foot_particles.emitting = false
  right_foot_particles.emitting = false