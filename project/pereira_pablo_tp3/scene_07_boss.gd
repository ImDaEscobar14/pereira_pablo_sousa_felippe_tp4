extends Node2D

@onready var boss_music: AudioStreamPlayer = $BossMusic

func _ready() -> void:
	if boss_music and not boss_music.playing:
		boss_music.play()
