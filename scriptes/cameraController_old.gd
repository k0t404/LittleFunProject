extends Camera3D

@export
var mouseSensativity: float = 0.5

var deltaYMovement: float = 0
	
	
func _input(event):
	if event is InputEventMouseMotion:
		rotate(Vector3.LEFT, deg_to_rad(-event.relative.y * mouseSensativity))
		deltaYMovement += -event.relative.y * mouseSensativity
		print(deltaYMovement)
		#if (-75 < deltaYMovement - -event.relative.y * mouseSensativity and deltaYMovement + -event.relative.y * mouseSensativity < 75):
		#	rotate(Vector3.LEFT, deg_to_rad(-event.relative.y * mouseSensativity))
		#	deltaYMovement += -event.relative.y * mouseSensativity
		#	print(deltaYMovement)
		#elif -75 < deltaYMovement - -event.relative.y * mouseSensativity and -event.relative.y * mouseSensativity < 0:
		#	deltaYMovement += -event.relative.y * mouseSensativity
		#elif deltaYMovement + -event.relative.y * mouseSensativity < 75 and -event.relative.y * mouseSensativity > 0:
		#	deltaYMovement += -event.relative.y * mouseSensativity
	#print(deltaYMovement, " ", -event.relative.y * mouseSensativity)
