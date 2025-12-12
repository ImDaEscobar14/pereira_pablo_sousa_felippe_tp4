extends Area2D

@export var next_scene_path: String = "res://scene_02.tscn"

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body.name == "player":  # nom exact du Player
		print("Player est entré dans la zone !")
		get_tree().change_scene_to_file(next_scene_path)
