extends Control

#game cest le node2d
@onready var game = $"../.."

func _on_reprendre_pressed() -> void:
	game.menu_toggle()


func _on_quitter_pressed() -> void:
	get_tree().quit()
