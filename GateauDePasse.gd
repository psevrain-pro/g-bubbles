extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	for i in $Emplacements.get_child_count():
		var cake = $Emplacements.get_child(i)
		cake.texture = load("res://Sprites/cake_%d.png"%(i+1))


func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT  && event.pressed:
			AudioManager.play_gui()
			get_tree().change_scene("res://Menu.tscn")
