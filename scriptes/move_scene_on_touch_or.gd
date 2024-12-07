extends Area3D

class_name MoveOnTouchOr

var controller: Node3D

func touch(touchMoveAble: TouchMoveAble):
	touchMoveAble.touched.emit(self)


func get_closest_TouchMoveAble():
	var list: Array[Area3D] = get_overlapping_areas()
	
	var distance: float
	
	var closest_distance: float = INF
	var closest: TouchMoveAble = null
	
	for touchMoveAble in list:
		distance = touchMoveAble.global_position.distance_to(global_position)
		
		if distance < closest_distance:
			closest = touchMoveAble as TouchMoveAble
			closest_distance = distance
	
	return closest		
