extends CharacterBody2D

@export var speed: float = 55.0
@export var hit_distance: float = 16.0
@export var hit_cooldown: float = 1.0  # temps entre le degat

var last_hit_time: float = 0.0
var game_over_triggered: bool = false

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var player := get_tree().current_scene.get_node_or_null("player/CharacterBody2D")

func _physics_process(delta):
	if player == null:
		return

	# Mouvement vers le player
	var direction = player.global_position - global_position
	if direction.length() > 1.0:
		velocity = direction.normalized() * speed
		move_and_slide()

		#  Animation 
		if abs(direction.x) > abs(direction.y):
			if direction.x > 0:
				animation.play("droite")
			else:
				animation.play("gauche")
		else:
			if direction.y > 0:
				animation.play("bas")
			else:
				animation.play("haut")

	# degats
	if global_position.distance_to(player.global_position) <= hit_distance:
		var current_time = Time.get_ticks_msec() / 1000.0

		if current_time - last_hit_time > hit_cooldown:
			last_hit_time = current_time

			if player.has_method("take_damage"):
				player.take_damage()  
