extends Node2D

# Pour tester le menu pause si nécessaire
@onready var menu = $game_over_ui/Menu
var is_paused = false

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		menu_toggle()

func menu_toggle():
	if is_paused:
		menu.hide()
		Engine.time_scale = 1 
	else:
		menu.show()
		Engine.time_scale = 0
	is_paused = not is_paused


# cetait aussi un test pour la porte et le zoom
func _on_ZoneZoom_body_entered(body):
	# check si cest le player
	if body.name == "player":  
		print("Player est entré dans la zone !")

		# Afficher un message rapide
		$ZoneZoom/Label.text = "Il me faudrait de la lumière pour m’avancer dans la cave."
		$ZoneZoom/Label.visible = true

		# Changement de la scene
		var err = get_tree().change_scene_to_file("res://scene_02.tscn")
		print("Résultat change_scene_to_file :", err)
