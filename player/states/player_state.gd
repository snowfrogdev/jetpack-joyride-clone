class_name PlayerState extends State

const RUNNING = "Running"
const FLYING = "Flying"
const FALLING = "Falling"
const DEAD = "Dead"

var player: Player

func _ready() -> void:
  player = owner as Player
  await owner.ready
  assert(player != null, "PlayerState must be attached to the Player node.")
