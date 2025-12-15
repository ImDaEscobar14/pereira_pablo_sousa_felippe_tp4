extends CharacterBody2D

@export var speed: float = 55.0
@export var hit_distance: float = 16.0
@export var hit_cooldown: float = 1.0

@export var max_hp: int = 3
var hp: int

var last_hit_time: float = 0.0

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D

# ✅ uses your working scene path method
@onready var player: CharacterBody2D = get_tree().current_scene.get_node_or_null("player/CharacterBody2D")

func _ready() -> void:
	add_to_group("monster")
	hp = max_hp

func _physics_process(delta: float) -> void:
	# If player wasn't found yet, try again
	if player == null:
		player = get_tree().current_scene.get_node_or_null("player/CharacterBody2D")
		return

	# Move toward player
	var direction = player.global_position - global_position

	if direction.length() > 1.0:
		velocity = direction.normalized() * speed
		move_and_slide()

		# Animation
		if abs(direction.x) > abs(direction.y):
			animation.play("droite" if direction.x > 0 else "gauche")
		else:
			animation.play("bas" if direction.y > 0 else "haut")

	# Damage player if close
	if global_position.distance_to(player.global_position) <= hit_distance:
		var current_time = Time.get_ticks_msec() / 1000.0
		if current_time - last_hit_time > hit_cooldown:
			last_hit_time = current_time
			if player.has_method("take_damage"):
				player.take_damage()

# Called by bullets
func take_damage(amount: int = 1) -> void:
	hp -= amount
	print("Monster HP:", hp)
	if hp <= 0:
		queue_free()
