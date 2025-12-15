extends Node

var keys_collected : int = 0
var has_gun: bool = false
var ammo: int = 0
var boss_dead: bool = false

func collect_key():
	keys_collected += 1
	
