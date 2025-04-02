extends Panel

var time: float = 7201
var hours: int = 0
var minutes: int = 0
var seconds: int = 0
var msec: int = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time -= delta
	msec = fmod(time, 1) * 1000
	seconds = fmod(time, 60)
	minutes = fmod(time, 3600) / 60
	hours = fmod(time, 360000) / 3600
	$Hours.text = "%03d:" % hours
	$Minutes.text = "%02d:" % minutes
	$Seconds.text = "%02d." % seconds
	$Msecs.text = "%03d" % msec


func add_time(seconds: Variant) -> void:
	time += seconds
