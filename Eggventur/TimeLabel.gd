extends Label

var time_alive := 0.0
var running := true

func _process(delta):
	if running:
		time_alive += delta
		
		var minutes = int(time_alive) / 60
		var seconds = int(time_alive) % 60
		
		text = "Time: %02d:%02d" % [minutes, seconds]

func stop_timer():
	running = false
