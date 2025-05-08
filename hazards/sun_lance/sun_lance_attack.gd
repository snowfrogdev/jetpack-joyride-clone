class_name SunLanceAttack extends Node2D

@export var tracking_speed: float = 5.0

@onready var player = $/root/Main/Game/Player
@onready var warning: Node2D = $Warning
@onready var tracking_warning_sprite: Sprite2D = $Warning/TrackingWarningSprite
@onready var locked_warning_sprite: Sprite2D = $Warning/LockedWarningSprite

var trigger_node: SunLanceTrigger
var detection_line: float

func init(trigger: SunLanceTrigger, detection_line_x: float):
  trigger_node = trigger
  detection_line = detection_line_x
