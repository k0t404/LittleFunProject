extends Node3D

var next_scen = preload("res://scenes and presets/main2.tscn")
var buttonPressed: bool;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if buttonPressed:
		await get_tree().create_timer(5).timeout
		get_tree().change_scene_to_packed(next_scen)
		buttonPressed = false


func _on_interactable_interacted(interactor: Interactor) -> void:
	buttonPressed = true
