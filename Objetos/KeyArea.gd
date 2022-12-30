extends Area

var can_move = true

func move(point, delta):
	var tween = get_parent().get_node("Tween")
	tween.interpolate_property(get_parent(), "global_translation", get_parent().global_translation, 
		point, delta + 0.2,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
#	var direction = get_parent().global_translation.angle_to(point)
#	get_parent().global_translation.move_toward(direction, delta)
	get_parent().mode = RigidBody.MODE_STATIC
	

func release():
	get_parent().mode = RigidBody.MODE_RIGID


func _on_Area_area_entered(area):
	print("entrou")
	if area.is_in_group("porta"):
		print("porta")
		can_move = false
		get_node("/root/World").chave_na_porta()
