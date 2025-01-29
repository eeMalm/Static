extends Node2D
@export var InnocentKilled : int = 0
@export var GuiltyKilled : int = 0
@export var InnocentReleased : int = 0
@export var GuiltyReleased : int = 0
@export var InnocentSeized : int = 0
@export var GuiltySeized : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$"Shift-over/GR".text = str(GuiltyReleased)
	$"Shift-over/GK".text = str(GuiltyKilled)
	$"Shift-over/IR".text = str(InnocentReleased)
	$"Shift-over/IK".text = str(InnocentKilled)
	$"Shift-over/GS".text = str(GuiltySeized)
	$"Shift-over/IS".text = str(InnocentSeized)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
