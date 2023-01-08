extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal seeds_changed

var seeds = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Player_seed_collected():
	seeds += 1
	
	emit_signal("seeds_changed", seeds)
