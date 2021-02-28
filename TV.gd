extends Sprite

export var MAX_ENERGY := 0.72
export var MIN_ENERGY := 0.66

onready var light := $CanvasLayer/Light2D
onready var timer := $FlickerTimer

var _fluctuation := rand_range(0.025, 0.075)
var _currentMinEnergy := MIN_ENERGY
var _currentMaxEnergy := MAX_ENERGY

func _on_FlickerTimer_timeout() -> void:
	light.energy += rand_range(-_fluctuation, _fluctuation)
	light.energy = clamp(light.energy, _currentMinEnergy, _currentMaxEnergy)
	timer.start(rand_range(0.005, 0.05))

func _on_Animation_update() -> void:
	_fluctuation = rand_range(0.025, 0.075)
	var mid := rand_range(MIN_ENERGY, MAX_ENERGY)
	_currentMinEnergy = mid - _fluctuation
	_currentMaxEnergy = mid + _fluctuation
	timer.stop()
	_on_FlickerTimer_timeout()
