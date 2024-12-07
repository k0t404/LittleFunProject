extends "res://scriptes/PlayerController.gd"

var stamina = 10000

func stamina_change(stamina_new, coeficient):
	stamina = lerp(float(stamina), float(stamina_new), coeficient)
	
