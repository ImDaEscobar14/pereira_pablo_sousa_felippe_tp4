extends Area2D
#cetait un test pour la flashlight mais ca na pas marcher
@onready var sprite = $Sprite2D
@onready var interact_label = get_node("/root/Node2D/CanvasLayer/LabelFlashlight")

var player_near = false
var collected = false

func _ready():
	monitoring = true
	monitorable = true
	if sprite:
		sprite.visible = true
	add_to_group("Flashlights") 


func _on_body_entered(body: Node2D) -> void:
	pass 
