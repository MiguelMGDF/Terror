extends Spatial

var piscando = false

var rng = RandomNumberGenerator.new()
func _ready():
	piscar()

func piscar():
	rng.randomize()
	var rand = rng.randf_range(0.05, 0.3)
	$Timer.start(rand)
	$OmniLight.light_energy = 0.3
	piscando = true

func espera_piscar():
	rng.randomize()
	var rand = rng.randf_range(0.1, 1.5)
	$Timer.start(rand)

func _on_Timer_timeout():
	if piscando:
		$OmniLight.light_energy = 1.0
		espera_piscar()
		piscando = false
	else:
		piscar()
