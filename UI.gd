extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var label = get_node("./hp_label")
onready var seeds_label = get_node("./seeds_label")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_hp_tracker_hp_changed(new_hp: float):
	label.text = "HP: %s" % new_hp
	


func _on_SeedTracker_seeds_changed(seeds):
	seeds_label.text = "SEEDS: %s" % seeds # Replace with function body.
