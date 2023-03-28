extends Sprite

func _ready():
	randomize()
	var rnd = randi()%4 +1 
	texture = load("res://Sprites/platformer_background_%d.png"%rnd)
