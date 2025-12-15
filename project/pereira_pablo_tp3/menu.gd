extends Control

var game: Node = null

func _ready() -> void:
	game = get_tree().get_first_node_in_group("game")

func _on_reprendre_pressed() -> void:
	if game and game.has_method("menu_toggle"):
		game.menu_toggle()
	else:
		push_warning("menu_toggle() not found. Make sure your World/Game node is in group 'game' and has menu_toggle().")

func _on_quitter_pressed() -> void:
	get_tree().quit()
