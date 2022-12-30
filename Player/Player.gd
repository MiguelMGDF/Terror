extends KinematicBody

const MOUSE_SENSE = 0.2
const SPEED = 2
var mouse_icon = preload("res://Player/Mouse_icon.png")
var interativo = false
var interagindo = null
signal olhando
#canplay vai dizer se o jogador pode movimentar o personagem
var canplay = false
var reading = false
var objects = {}
var pressed = false

onready var camera = $CameraNode
onready var icon = $InteragirIcon
onready var local_interacao = $CameraNode/Interagindo_local

var input_move = Vector3()

#deixa o jogador se mexer
func startplay():
	canplay = true

func _ready():
	pass
	#Captura o mouse
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	#movimentos de camera em primeira pessoa geral
	if event is InputEventMouseMotion and canplay:
		self.rotate_y(deg2rad(-1 * event.relative.x * MOUSE_SENSE))
		camera.rotate_x(deg2rad(event.relative.y * MOUSE_SENSE))
		camera.rotation.x = clamp(camera.rotation.x, deg2rad(-90), deg2rad(90))

func _physics_process(delta):
	if canplay:
		#pega a direção do input
		var input = get_input_direction()
		move_and_slide(input * SPEED, Vector3.UP)
	#envia o sinal se estiver olhando para a esquerda
	if self.rotation_degrees.y > -100 and self.rotation_degrees.y < -80:
		emit_signal("olhando")
	#se tiver um interativo, mostra o icone de interação
	if objects.size() != 0:
		if interativo:
			icon.visible = true
			icon.global_translation = interagindo.global_translation + Vector3(0, 0.17, 0)
			icon.rotation = Vector3(0, deg2rad(180), 0)
	else:
		icon.visible = false
	
	#ação de interagir, como são opções limitadas, pode-se colocar as interações dentro do código do player
	if Input.is_action_pressed("interagir"):
		icon.visible = false
		if interagindo != null:
			if interagindo.is_in_group("chave"):
				if interagindo.can_move:
					pressed = true
					interagindo.move(local_interacao.global_translation, delta)
			elif interagindo.is_in_group("carta"):
				$Canvas/Carta.show()
				canplay = false
			else:
				interagindo.interagir()
	
	
	if Input.is_action_just_released("interagir"):
		pressed = false
		canplay = true
		$Canvas/Carta.hide()
		if !objects.size() >= 1:
			if interativo:
				interativo = true
				if interagindo.has_method("release"):
					interagindo.release()
		release(interagindo)


func get_input_direction() -> Vector3:
	#pega os inputs e transforma em direções
	var z: float = (Input.get_action_strength("up")) - Input.get_action_strength("down")
	var x: float = (Input.get_action_strength("left")) - Input.get_action_strength("right")
	var direct = transform.basis.xform(Vector3(x, 0, z).normalized())
	return direct

#verifica se algum objeto interativo entrou e bota o ícone de interação
func _on_Area_area_entered(area):
	if area.is_in_group("Interativo"):
		if !objects.has(area):
			objects[str(area)] = area
			if  interagindo == null:
				interagindo = objects[str(area)]
				interativo = true

#Da o jumpscare mostrando a imagem e dando play no som
func jumpscare():
	$Canvas/Jumpscare.show()
	$JumpscareSound.play()

#retira icone de interação
func _on_Area_area_exited(area):
	if !pressed or interagindo == null:
		if objects.has(str(area)):
			release(str(area))

func release(area):
	if objects.size() > 1:
		for i in objects:
			if objects.has(i):
				if objects[i] != null:
					interagindo = objects[i]
		objects.erase(str(area))
	else:
		objects.erase(str(area))
		interativo = false
		interagindo = null

#mostra tela de finalização quando acabar o jumpscare
func _on_JumpscareSound_finished():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$EndScreen/Fundo.show()

#volta para o menu
func _on_JogarNovamente_pressed():
	print("pressed")
	var menu = load("res://MainMenu.tscn")
	get_tree().change_scene_to(menu)
