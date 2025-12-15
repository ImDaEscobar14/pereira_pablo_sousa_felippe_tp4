extends Area2D

func _ready() -> void:
	if GameState.has_gun:
		queue_free()
		return

	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body.has_method("equip_gun"):
		body.equip_gun()
		queue_free()
