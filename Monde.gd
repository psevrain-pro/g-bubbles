extends Node2D

onready var tscn_bulle = preload("res://Bulle.tscn")
var tour: int
var score: int
var waiting = false

var animaux = ["[color=yellow][fade start=1 length=12]abeille[/fade][/color]", 
	"hirondelle", 
	"[color=maroon]gazelle[/color]", 
	"[tornado radius=5 freq=2]nymphe[/tornado]", 
	"[color=fuchsia]fée[/color]", 
	"[rainbow]  LICORNE  [/rainbow]"]

var qualificatifs = ["[color=gray]timide[/color]", 
	"[color=blue]paisible[/color]", 
	"[color=yellow]travailleuse[/color]", 
	"[color=lime]courageuse[/color]", 
	"[color=red]redoutable[/color]", 
	"[rainbow]extraordinaire[/rainbow]"]

var royaumes = ["[color=green]des bois[/color]", 
	"[tornado radius=5 freq=2]des neiges[/tornado]", 
	"des [wave amp=50 freq=2][color=aqua]océans[/color][/wave]", 
	"[rainbow]des arcs en ciel[/rainbow]"]

func _ready():
	randomize()
	tour = 0
	score = 0
	_init_tour()


func _init_tour():
	var enigmes
	match Game.niveau:
		1: enigmes = _start_lvl_1()
		2: enigmes = _start_lvl_2()
		3: enigmes = _start_lvl_3()
		4: enigmes = _start_lvl_4()
		
	var maxi = 0
	for e in enigmes:
		if e.valeur > maxi:
			maxi = e.valeur
	
	for i in len(enigmes):
		var e = enigmes[i]
		_spawn_bulle(i+1, randi()%3, e.texte, e.valeur, e.valeur==maxi )
	
	waiting = false

func choix(the_one: bool):
	if waiting : return
	
	waiting = true
	AudioManager.play_gui()
	for b in $Bulles.get_children():
		b.depop()
	yield(get_tree().create_timer(0.5), "timeout")
	
	var icone = $Progression.get_child(tour)
	if the_one:
		icone.change_status(icone.STATUS.OK)
		score += 1
		AudioManager.play("res://Sounds/success.mp3")
	else : 
		icone.change_status(icone.STATUS.KO)
		AudioManager.play("res://Sounds/wrong.mp3")

	yield(get_tree().create_timer(1), "timeout")
	if tour >= 4:
		fin_partie()
	else :
		tour += 1
		_init_tour()


func fin_partie():
	$Chrono.stop()
	$Instructions.visible = false
	Game.last = _compute_name()
	Game.sauvegarde()
	
	$Popup.popup()
	yield(get_tree().create_timer(0.5), "timeout")
	$Popup/TuEs.bbcode_text = Game.last
	if score ==5 :
		AudioManager.play("res://Sounds/fanfare_plus.mp3")
	else :
		AudioManager.play("res://Sounds/fanfare.mp3")

func fermeture():
	AudioManager.play_gui()
	get_tree().change_scene("res://Menu.tscn")

func _start_lvl_1():
	var enigmes = []
	enigmes.append(_get_enigm_lvl_1())
	enigmes.append(_get_enigm_lvl_1())
	return enigmes

func _start_lvl_2():
	var enigmes = []
	enigmes.append(_get_enigm_lvl_2())
	enigmes.append(_get_enigm_lvl_2())
	return enigmes

func _start_lvl_3():
	var enigmes = []
	enigmes.append(_get_enigm_lvl_2())
	enigmes.append(_get_enigm_lvl_2())
	enigmes.append(_get_enigm_lvl_2())
	return enigmes
	
func _start_lvl_4():
	var enigmes = []
	enigmes.append(_get_enigm_lvl_3())
	enigmes.append(_get_enigm_lvl_3())
	enigmes.append(_get_enigm_lvl_3())
	return enigmes


# additions
func _get_enigm_lvl_1():
	var c1 = randi()%8+1
	var c2 = randi()%(10-c1) + 1
	return {texte = "%d+%d"%[c1, c2], valeur = c1+c2}

# soustractions
func _get_enigm_lvl_2():
	if randi()%2 >=1:
		var c1 = randi()%5+5
		var c2 = randi()%(c1-1) + 1
		return {texte = "%d-%d"%[c1, c2], valeur = c1-c2}
	else :
		return _get_enigm_lvl_1()

# soustractions > 10
func _get_enigm_lvl_3():
	if randi()%2 >=1:
		var c1 = randi()%15+5
		var c2 = randi()%(c1-1) + 1
		return {texte = "%d-%d"%[c1, c2], valeur = c1-c2}
	else :
		return _get_enigm_lvl_1()

func _spawn_bulle(zone: int, couleur: int, texte: String, solution: int, is_the_one: bool):
	var b = tscn_bulle.instance()
	$Bulles.add_child(b)
	match zone :
		1:
			b.init(100,400, 170, 500, couleur, texte, solution, is_the_one)
		3:
			b.init(515, 516, 170, 500, couleur, texte, solution, is_the_one)
		2:
			b.init(650,930, 170, 500, couleur, texte, solution, is_the_one)
			
	b.connect("signal_pressed", self, "choix")
	return b


func _compute_name() -> String:
	var score_temps = clamp (round(5 - ($Chrono.secondes /10)), 0, 4)
	var nom = "%s %s %s."% [qualificatifs[score_temps], animaux[score], royaumes[Game.niveau-1] ]
	#var nom = "%s %s %s."% [qualificatifs[5], animaux[5], royaumes[3] ]
	return nom		
	
	
