extends Label

var secondes

# Called when the node enters the scene tree for the first time.
func _ready():
	secondes = 0
	self.text = "%d s" % secondes


func stop():
	$Timer.stop()


func _on_Timer_timeout():
	secondes += 1 
	self.text = "%d s" % secondes
