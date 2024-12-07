extends GotHitOr

@export var hit_thing: MeshInstance3D

var cached_closest: GotHitAble

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	controller = hit_thing

func _physics_process(delta: float) -> void:
	var new_closest: GotHitAble = get_closest_GotHitAble()
	if new_closest != cached_closest:
		hit(new_closest)
		cached_closest = new_closest


func _on_area_exited(area: GotHitAble):
	if cached_closest == area:
		hit(area)
