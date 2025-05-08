class_name SunLanceState extends State

const WARNING = "Warning"
const FIRING = "Firing"
const FIRED = "Fired"

var sun_lance_attack: SunLanceAttack

func _ready() -> void:
  sun_lance_attack = owner as SunLanceAttack
  await owner.ready
  assert(sun_lance_attack != null, "SunLanceState must be attached to the SunLanceAttack node.")
