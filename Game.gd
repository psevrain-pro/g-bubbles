extends Node

const FILE_NAME  = "user://jeu_des_bulles.tres"

var niveau = 1
var last = ""

func _ready():
	charge()

func sauvegarde():
	var file = File.new()
	file.open(FILE_NAME, File.WRITE)
	file.store_var(last)
	file.close()

func charge():
	var file = File.new()
	if file.file_exists(FILE_NAME):
		file.open(FILE_NAME, File.READ)
		last = file.get_var()
		file.close()
	else:
		last = ""
