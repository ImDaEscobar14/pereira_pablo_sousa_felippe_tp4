extends Area2D

@export var boss_scene: PackedScene
@export var spawn_point: NodePath

var spawned := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if spawned:
		return
	if not body.is_in_group("player"):
		return

	spawned = true
