extends Area3D

class_name GotHitOr

var controller: Node3D

func hit(gotHitAble: GotHitAble):
	gotHitAble.hitted.emit(self)


func get_closest_GotHitAble():
	var list: Array[Area3D] = get_overlapping_areas()
	
	var distance: float
	
	var closest_distance: float = INF
	var closest: GotHitAble = null
	
	for gotHitAble in list:
		distance = gotHitAble.global_position.distance_to(global_position)
		
		if distance < closest_distance:
			closest = gotHitAble as GotHitAble
			closest_distance = distance
	
	return closest		
