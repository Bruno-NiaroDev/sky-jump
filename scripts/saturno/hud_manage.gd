extends Control

@onready var crystal_counter: Label = $container/crystal_container/crystal_counter
@onready var timer_counter: Label = $container/timer_container/timer_counter
@onready var life_counter: Label = $container/life_container/life_counter
@onready var clock_timer := $clock_timer as Timer

var minutes := 0
var seconds := 0

signal time_updated(minutes, seconds)

func _ready() -> void:
	crystal_counter.text = str("%04d" % Globals.crystals)
	life_counter.text = str("%02d" % Globals.player_life)
	timer_counter.text = format_time()
	clock_timer.start()  # começa o contador

func _process(delta: float) -> void:
	# Atualiza HUD de acordo com os valores globais
	crystal_counter.text = str("%04d" % Globals.crystals)
	life_counter.text = str("%02d" % Globals.player_life)

func _on_clock_timer_timeout() -> void:
	# Incrementa o tempo
	seconds += 1
	if seconds >= 60:
		seconds = 0
		minutes += 1
	
	timer_counter.text = format_time()
	emit_signal("time_updated", minutes, seconds)

func format_time() -> String:
	return str("%02d" % minutes) + ":" + str("%02d" % seconds)

func reset_clock_timer() -> void:
	minutes = 0
	seconds = 0
	timer_counter.text = format_time()
