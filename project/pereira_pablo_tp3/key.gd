extends Area2D

# si la cle est collecter
var collected = false

# laudio pour la cle
@onready var sound_player: AudioStreamPlayer2D = $item_collected_sound

func _ready():
	# pour le lien du body au truc
	body_entered.connect(_on_body_entered)
	
# confirme la collecte de la key
func _on_body_entered(body: Node) -> void:
	if collected:
		return  

	
	if body.is_in_group("player"):
		collected = true
		body.has_key = true 

		# Joue le son 
		if sound_player and sound_player.stream:
			sound_player.play()
			# ca attend que le son finis
			await get_tree().create_timer(sound_player.stream.get_length()).timeout

		print("Clé récupérée !")
		queue_free()  # Supprime la cle de la scne
