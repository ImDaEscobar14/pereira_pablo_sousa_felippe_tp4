extends Area2D

@export var next_scene: String = "res://scene_02.tscn"  

@onready var message_label: Label = $Label
var player: Player = null

func _ready():
	message_label.visible = false
	message_label.text = "Il me faudrait une torche"
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

func _on_body_entered(body):
	if body.is_in_group("player"):
		player = body

		# Si le joueur a pas la key
		if not player.has_key:
			message_label.visible = true
			return

		# cetait tuff mais cest le changement de scene 
		if next_scene != "":
			get_tree().change_scene_to_file(next_scene)

func _on_body_exited(body):
	if body.is_in_group("player"):
		message_label.visible = false
		player = null
