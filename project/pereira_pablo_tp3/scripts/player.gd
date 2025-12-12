extends CharacterBody2D
class_name Player

@export var speed: float = 400.0

# Nodes
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var pas_son: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var overlay: ColorRect = $CanvasLayer/OverlayRed

# bruit degats
@onready var damage_sound: AudioStreamPlayer2D = $DamageSound

# Game Over UI 
@onready var game_over_ui = get_tree().root.get_node("World/game_over_ui") # ← change "World" au besoin
@onready var game_over_label = game_over_ui.get_node("game_over_label") if game_over_ui else null
@onready var restart_button = game_over_ui.get_node("bouton_recommencer") if game_over_ui else null

# vitesse
const SPEED = 75.0
var directionName = "bas"

# vie
var max_health := 3
var health := max_health

# key
var has_key: bool = false

func _ready():
	add_to_group("player")
	update_overlay()

	# Cacher l'UI au début
	if game_over_label:
		game_over_label.visible = false
	if restart_button:
		restart_button.visible = false

func _physics_process(_delta):
	var direction = Vector2(
		Input.get_axis("gauche", "droite"),
		Input.get_axis("haut", "bas")
	)

	if direction != Vector2.ZERO:
		velocity = direction.normalized() * SPEED
		if not pas_son.playing:
			pas_son.pitch_scale = randf_range(0.8, 1.4)
			pas_son.play()
	else:
		velocity = Vector2.ZERO
		if pas_son.playing:
			pas_son.stop()

	# Animation
	if direction != Vector2.ZERO:
		if abs(direction.x) > abs(direction.y):
			directionName = "droite" if direction.x > 0 else "gauche"
		else:
			directionName = "haut" if direction.y < 0 else "bas"

	if direction == Vector2.ZERO:
		match directionName:
			"haut": animation.play("animation_idle")
			"gauche": animation.play("animation_idle_gauche")
			"droite": animation.play("animation_idle_droite")
			"bas": animation.play("animation_idle")
	else:
		animation.play("animation_" + directionName)

	move_and_slide()

# health

func take_damage():
	if health <= 0:
		return

	# jouer le son degats
	if damage_sound:
		damage_sound.play()

	health -= 1
	update_overlay()

	if health <= 0:
		die()

func heal():
	if health < max_health:
		health += 1
		update_overlay()

func update_overlay():
	if overlay == null:
		return

	match health:
		3: overlay.modulate.a = 0.0
		2: overlay.modulate.a = 0.4
		1: overlay.modulate.a = 0.7
		0: overlay.modulate.a = 1.0

func die():
	print("Player est mort !")

	set_physics_process(false)
	velocity = Vector2.ZERO
	animation.play("animation_idle")

	# UI game over
	if game_over_label:
		game_over_label.visible = true

	if restart_button:
		restart_button.visible = true
		if not restart_button.pressed.is_connected(_on_restart_pressed):
			restart_button.pressed.connect(_on_restart_pressed)

func _on_restart_pressed():
	get_tree().reload_current_scene()
