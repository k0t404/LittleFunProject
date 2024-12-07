#@tool
#extends Node3D
#
#
#@export var weapon_type: Weapons:
	#set(value):
		#weapon_type = value
		#if Engine.is_editor_hint():
			#load_weapon()
#
#
#
#func _ready() -> void:
	#load_weapon()
#
#
#
#
#func load_weapon() -> void:
	#position = weapon_type.position
	#rotation_degrees = weapon_type.rotation
	
