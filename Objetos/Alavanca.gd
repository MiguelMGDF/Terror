extends Spatial

func interagir():
	get_parent().get_node("Animacao").play("Alavanca")

func alavanca_abaixada():
	get_node("/root/World").mudar_mapa()
