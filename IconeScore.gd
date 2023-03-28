extends AnimatedSprite

onready var particules_tscn = preload("res://ParticlesMagic.tscn")

enum STATUS {GREY, OK, KO}


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func change_status(new_status: int):
	match new_status:
		STATUS.GREY:
			play("default")
		STATUS.OK:
			play("OK")
			var p = particules_tscn.instance()
			get_node("/root").add_child(p)
			p.global_position = self.global_position
		STATUS.KO:
			play("KO")


