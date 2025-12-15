extends CanvasLayer

@onready var game_over_label: Label = $game_over_label
@onready var restart_button: Button = $bouton_recommencer

func _ready() -> void:
	visible = false


	process_mode = Node.PROCESS_MODE_ALWAYS

	if restart_button and not restart_button.pressed.is_connected(_on_restart_pressed):
		restart_button.pressed.connect(_on_restart_pressed)

func show_game_over() -> void:
	visible = true
	if game_over_label:
		game_over_label.visible = true
	if restart_button:
		restart_button.visible = true

func _on_restart_pressed() -> void:

	get_tree().paused = false


	if Engine.has_singleton("GameState") or true:
		GameState.boss_dead = false

	get_tree().reload_current_scene()
