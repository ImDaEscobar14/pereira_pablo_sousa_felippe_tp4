extends Node2D

@onready var droite_music: AudioStreamPlayer2D = $droite_music

func _ready() -> void:
	if droite_music and not droite_music.playing:
		droite_music.play()
