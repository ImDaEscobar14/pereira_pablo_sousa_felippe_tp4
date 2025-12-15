extends Area2D

@export var lifetime: float = 7.0

# If your bullet PNG is drawn facing LEFT, keep this at 180.
# If you redraw it facing RIGHT, set this to 0.
@export var sprite_rotation_offset_deg: float = 180.0

var velocity: Vector2 = Vector2.ZERO
var damage: int = 1

func setup(dir: Vector2, speed: float, dmg: int = 1) -> void:
	velocity = dir.normalized() * speed
	damage = dmg
	rotation = velocity.angle() + deg_to_rad(sprite_rotation_offset_deg)

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	global_position += velocity * delta
	lifetime -= delta
	if lifetime <= 0.0:
		queue_free()

func _on_body_entered(body: Node) -> void:
	# Don't delete bullet if it touches the player
	if body.is_in_group("player"):
		return

	if body.is_in_group("monster") and body.has_method("take_damage"):
		body.take_damage(damage)

	queue_free()
