extends Area


var trancado = true
var aberta = false

func _ready():
	pass # Replace with function body.

func interagir():
	if !trancado and !aberta:
		get_node("Animacao").play("Open")

func fechar():
	get_parent().get_node("Animacao").play("Close")

func set_aberta():
	trancado = false
	aberta = false

func set_open():
	aberta = true
	$CollisionShape.queue_free()
