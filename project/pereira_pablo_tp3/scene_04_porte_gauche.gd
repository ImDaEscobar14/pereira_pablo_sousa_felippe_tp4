extends Node2D

@onready var gauche_music: AudioStreamPlayer2D = $gauche_music

func _ready() -> void:
	if gauche_music and not gauche_music.playing:
		gauche_music.play()
