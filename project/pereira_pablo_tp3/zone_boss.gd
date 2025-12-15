extends Area2D

@export var next_scene: String = "res://scene_07_boss.tscn"  
@onready var message_label: Label = $Label  
var player: Player = null
var can_pass := false  

func _ready() -> void:
	if message_label:
		message_label.visible = false
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _process(delta):
	if player and message_label:
		if player.has_gun and player.ammo > 0 and not can_pass:
			can_pass = true
			message_label.visible = false
			if next_scene != "":
				get_tree().change_scene_to_file(next_scene)

func _on_body_entered(body: Node) -> void:
	if not body.is_in_group("player"):
		return
	player = body as Player

	if not player.has_gun or player.ammo <= 0:
		can_pass = false
		if message_label:
			message_label.text = "Il me faudrait une arme et des balles avant d'avancer"
			message_label.visible = true
	else:
		can_pass = true
		if message_label:
			message_label.visible = false
		if next_scene != "":
			get_tree().change_scene_to_file(next_scene)

func _on_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		player = null
		if message_label:
			message_label.visible = false
