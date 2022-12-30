extends Spatial

onready var level = preload("res://World.tscn")

#muda a cena pro nivel
func mudar_cena():
	get_tree().change_scene_to(level)

#inicia o fadeout
func _on_Jogarbtn_pressed():
	$Fadeout.play("Fadeout")
