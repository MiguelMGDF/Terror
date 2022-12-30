extends SpotLight

var piscando = false

var rng = RandomNumberGenerator.new()
func _ready():
	pass

func piscar():
	if !get_node("/root/World").animando and get_node("/root/World").corredor:
		rng.randomize()
		var rand = rng.randf_range(0.05, 0.3)
		$Timer.start(rand)
		self.light_energy = 0.5
		piscando = true
		$Som.play()
	else:
		light_energy = 5

func espera_piscar():
	if !get_node("/root/World").animando and get_node("/root/World").corredor:
		rng.randomize()
		var rand = rng.randf_range(0.1, 1.5)
		$Timer.start(rand)
		$Som.stop()
	else:
		light_energy = 5

func _on_Timer_timeout():
	if !get_node("/root/World").animando:
		if piscando:
			light_energy = 5.0
			espera_piscar()
			piscando = false
			$Som.playing = false
		else:
			piscar()
