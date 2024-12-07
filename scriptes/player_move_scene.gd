extends MoveOnTouchOr

@export var player: CharacterBody3D

var cached_closest: TouchMoveAble

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	controller = player

func _physics_process(delta: float) -> void:
	var new_closest: TouchMoveAble = get_closest_TouchMoveAble()
	if new_closest != cached_closest:
		touch(new_closest)
		cached_closest = new_closest


func _on_area_exited(area: TouchMoveAble):
	if cached_closest == area:
		touch(area)
