extends CharacterBody2D
class_name Player

@export var speed: float = 400.0

@export var bullet_scene: PackedScene
@export var bullet_speed: float = 700.0
@export var shoot_cooldown: float = 0.2
@export var bullet_spawn_push: float = 10.0

@export var gun_offset_right: Vector2 = Vector2(-5, 0)
@export var gun_offset_left: Vector2 = Vector2(-25, 0)
@export var gun_offset_up: Vector2 = Vector2(-13, -6)
@export var gun_offset_down: Vector2 = Vector2(6, 6)

@export var gun_z_front: int = 20
@export var gun_z_back: int = 5 

var has_gun: bool = false
var ammo: int = 0
var shoot_timer: float = 0.0

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var pas_son: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var overlay: ColorRect = $CanvasLayer/OverlayRed
@onready var damage_sound: AudioStreamPlayer2D = $DamageSound

@onready var shoot_sound: AudioStreamPlayer2D = get_node_or_null("ShootSound")

@onready var gun_holder: Node2D = get_node_or_null("GunHolder")
@onready var gun_sprite: Sprite2D = get_node_or_null("GunHolder/GunSprite")
@onready var muzzle: Marker2D = get_node_or_null("GunHolder/Muzzle")

var muzzle_base_pos: Vector2 = Vector2.ZERO

@onready var game_over_ui: CanvasLayer = get_tree().current_scene.get_node_or_null("game_over_ui")

const SPEED = 75.0
var directionName: String = "bas"

var max_health := 3
var health := max_health

var has_key: bool = false

func _ready():
	add_to_group("player")
	update_overlay()

	if gun_holder:
		gun_holder.visible = false

	if muzzle:
		muzzle_base_pos = muzzle.position
		muzzle_base_pos.x = abs(muzzle_base_pos.x)

	has_gun = GameState.has_gun
	ammo = GameState.ammo

	if has_gun and gun_holder:
		gun_holder.visible = true
		update_gun_direction()

func _physics_process(delta):

	shoot_timer = max(0.0, shoot_timer - delta)

	var move_input := Vector2(
		Input.get_axis("gauche", "droite"),
		Input.get_axis("haut", "bas")
	)

	if move_input != Vector2.ZERO:
		velocity = move_input.normalized() * SPEED
		if not pas_son.playing:
			pas_son.pitch_scale = randf_range(0.8, 1.4)
			pas_son.play()
	else:
		velocity = Vector2.ZERO
		if pas_son.playing:
			pas_son.stop()

	if move_input != Vector2.ZERO:
		if abs(move_input.x) > abs(move_input.y):
			directionName = "droite" if move_input.x > 0 else "gauche"
		else:
			directionName = "haut" if move_input.y < 0 else "bas"

	update_gun_direction()

	if move_input == Vector2.ZERO:
		match directionName:
			"haut": animation.play("animation_idle")
			"gauche": animation.play("animation_idle_gauche")
			"droite": animation.play("animation_idle_droite")
			"bas": animation.play("animation_idle")
	else:
		animation.play("animation_" + directionName)

	if has_gun and Input.is_action_just_pressed("shoot"):
		try_shoot()

	move_and_slide()

func try_shoot() -> void:
	if ammo <= 0:
		return
	if shoot_timer != 0.0:
		return
	if bullet_scene == null:
		return

	if shoot_sound:
		shoot_sound.pitch_scale = randf_range(0.95, 1.05)
		shoot_sound.play()

	var dir: Vector2 = get_gun_dir()

	var b = bullet_scene.instantiate()
	get_tree().current_scene.add_child(b)

	var spawn_pos: Vector2 = global_position
	if muzzle:
		spawn_pos = muzzle.global_position

	spawn_pos += dir * bullet_spawn_push
	b.global_position = spawn_pos

	if b.has_method("setup"):
		b.setup(dir, bullet_speed, 1)

	ammo -= 1
	GameState.ammo = ammo 
	shoot_timer = shoot_cooldown

func update_gun_direction() -> void:
	if not has_gun or gun_holder == null:
		return

	if muzzle:
		muzzle.position = muzzle_base_pos

	match directionName:
		"droite":
			gun_holder.z_index = gun_z_front
			gun_holder.position = gun_offset_right
			gun_holder.rotation_degrees = 0
			if gun_sprite:
				gun_sprite.flip_h = false
			if muzzle:
				muzzle.position.x = muzzle_base_pos.x

		"gauche":
			gun_holder.z_index = gun_z_front
			gun_holder.position = gun_offset_left
			gun_holder.rotation_degrees = 0
			if gun_sprite:
				gun_sprite.flip_h = true
			if muzzle:
				muzzle.position.x = -muzzle_base_pos.x

		"haut":
			gun_holder.z_index = gun_z_back
			gun_holder.position = gun_offset_up
			gun_holder.rotation_degrees = -90
			if gun_sprite:
				gun_sprite.flip_h = false

		"bas":
			gun_holder.z_index = gun_z_front
			gun_holder.position = gun_offset_down
			gun_holder.rotation_degrees = 90
			if gun_sprite:
				gun_sprite.flip_h = false

func get_gun_dir() -> Vector2:
	if gun_holder:
		if is_equal_approx(gun_holder.rotation_degrees, -90.0):
			return Vector2.UP
		if is_equal_approx(gun_holder.rotation_degrees, 90.0):
			return Vector2.DOWN

	if gun_sprite and gun_sprite.flip_h:
		return Vector2.LEFT

	return Vector2.RIGHT

func take_damage():
	if health <= 0:
		return

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

	if game_over_ui and game_over_ui.has_method("show_game_over"):
		game_over_ui.show_game_over()

func equip_gun() -> void:
	has_gun = true
	GameState.has_gun = true

	if gun_holder:
		gun_holder.visible = true
		update_gun_direction()

func add_ammo(amount: int = 1) -> void:
	ammo += amount
	GameState.ammo = ammo
