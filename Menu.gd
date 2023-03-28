extends Node2D

var musiques = []

func _ready():
	if Game.last != "":
		$Last.bbcode_text = "La dernière fois tu étais une... \n%s"%Game.last
	
	musiques.append("res://Sounds/Happy-Birthday-Kids.mp3")
	musiques.append("res://Sounds/Happy-Birthday-Tunes.mp3")
	musiques.append("res://Sounds/Upbeat-Birthday-Song.mp3")
	
	AudioManager.play("res://Sounds/intro.mp3")
	
func _start(niveau):
	AudioManager.play_gui()
	Game.niveau = niveau
	get_tree().change_scene("res://Monde.tscn")


func _on_ButtonMusic_pressed():
	if AudioManager.is_playing_music():
		AudioManager.stop_music()
	else :
		var m = musiques[randi()% musiques.size()]
		AudioManager.play_music(m, 0)
