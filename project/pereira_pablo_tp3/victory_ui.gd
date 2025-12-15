extends CanvasLayer

# Drag your FIRST LEVEL scene here (your first Node2D .tscn)
@export var first_scene: PackedScene

@onready var victory_label: Label = $victory_label
@onready var menu_button: Button = $bouton_menu

func _ready() -> void:
	add_to_group("ui")
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS

	if menu_button and not menu_button.pressed.is_connected(_on_menu_pressed):
		menu_button.pressed.connect(_on_menu_pressed)

	# If boss already dead (ex: you changed scenes), still show victory
	if GameState.boss_dead:
		show_victory()

func show_victory() -> void:
	visible = true
	if victory_label:
		victory_label.visible = true
	if menu_button:
		menu_button.visible = true

func _on_menu_pressed() -> void:
	get_tree().paused = false

	# Reset global state for a fresh run
	GameState.has_gun = false
	GameState.ammo = 0
	GameState.boss_dead = false

	# Go back to the FIRST scene
	if first_scene:
		get_tree().change_scene_to_packed(first_scene)
	else:
		push_error("victory_ui.gd: first_scene is NOT set in Inspector!")
