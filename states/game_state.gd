class_name GameState extends State

const READY = "Ready"
const RUNNING = "Running"
const DYING = "Dying"
const GAMEOVER = "Dead"

var main: Main
var game: Game

func _ready() -> void:
  main = owner as Main
  await owner.ready
  assert(main != null, "GameState must be attached to the Main node.")
  
  game = %Game as Game
  assert(game != null, "Game node is not loaded.")
