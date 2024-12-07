extends Interactor

@export var player: CharacterBody3D

var cached_closest: Interactable

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	controller = player


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var new_closest: Interactable = get_closest_interactable()
	if new_closest != cached_closest:
		if is_instance_valid(cached_closest):
			unfocus(cached_closest)
		if new_closest:
			focus(new_closest)
		
		cached_closest = new_closest

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if cached_closest:
			interact(cached_closest)

func _on_area_exited(area: Interactable):
	if cached_closest == area:
		unfocus(area)
