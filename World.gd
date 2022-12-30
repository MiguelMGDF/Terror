extends Spatial

onready var animacoes = $Animacoes
var trancado = false
var corredor = false
var animando = false

onready var luz = $Mina/Corredor/Lampadas/MeshInstance5/SpotLight2

func _ready():
	animacoes.play("FadeIn")
	#conecta para iniciar o jumpscare
	$Player.connect("olhando", self, "jumpscare")

func mudar_mapa():
	#muda a posição dos mapas para ter uma transição entre eles
	get_node("Cave/Dark").queue_free()
	$Sala1.translation = Vector3(0, 0, 10)
	$Mina.translation = Vector3.ZERO
	corredor = true
	#começa a piscar a luz
	luz.piscar()

func jumpscare():
	#condições para o jumpscare
	if !animando and corredor:
		animacoes.play("jumpscare")
		animando = true

func chave_na_porta():
	animacoes.play("chave")

func _on_PlayerDetector_body_entered(body):
	#detecta se o player entrou e então fecha a porta
	if body.name == "Player" and !trancado:
		$Sala1/Door.get_node("Animacao").play("Close")
		trancado = true
