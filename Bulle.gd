extends Area2D

enum COULEUR {ROUGE, BLEU, VERT}

var sprites : Dictionary
var the_one: bool
var solution : int
signal signal_pressed


func _ready():
	randomize()
	sprites[COULEUR.ROUGE] = preload("res://Sprites/bulle_rouge.png")
	sprites[COULEUR.BLEU] = preload("res://Sprites/bulle_bleue.png")
	sprites[COULEUR.VERT] = preload("res://Sprites/bulle_verte.png")

func init(x_min:int, x_max: int, y_min: int, y_max: int, couleur: int, texte: String, i_solution: int, is_the_one: bool):
	position.x = randi()% (x_max - x_min) + x_min
	position.y = randi()% (y_max - y_min) + y_min
	solution = i_solution
	self.scale = Vector2.ONE * 0.1
	$Sprite.texture = sprites[couleur]
	$Label.text = texte
	the_one = is_the_one
	
	$Tween.interpolate_property(self, "scale",
		Vector2.ONE * 0.1, Vector2.ONE, 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()


func depop():
	$Label.text = "%d"% solution
	yield(get_tree().create_timer(0.7), "timeout")
	$Tween.interpolate_property(self, "scale", Vector2.ONE, Vector2.ONE * 0.3, 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	yield(get_tree().create_timer(0.3), "timeout")
	queue_free()



func _on_Bulle_input_event(viewport, event, shape_idx):
		if event is InputEventMouseButton:
			if event.button_index == BUTTON_LEFT  && event.pressed:
				self.scale.x = 1.4
				self.scale.y = 1.4
				emit_signal("signal_pressed", the_one)
