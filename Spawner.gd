extends Path2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var main_node = get_node("/root/Main")
onready var Utility = preload("res://Utility.gd")

var mob_scene = preload("res://Mob.tscn")

export var mob_probability = {
	"carrot": 4,
	"onion": 1
}

export var mob_types = {
	"onion": {
		"hp": 60,
		"dmg": 30,
		"spriteFrames": preload("res://anims/onion.tres"),
		"speed": 100
	},
	"carrot": {
		"hp": 25,
		"dmg": 20,
		"spriteFrames": preload("res://anims/carrot.tres"),
		"speed": 70
	}
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _draw():
	pass
	#draw_polyline(curve.get_baked_points(), Color.aquamarine, 5, true)


func get_random_mob_type(): 
	var types = mob_types.keys()
	var probabilites = []
	
	for type in types:
		probabilites.push_back(mob_probability[type])
		
	var type_key = Utility.weighted_rand(types, probabilites)
	return mob_types[type_key]

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func spawn_random_mob():
	$PathFollow2D.unit_offset = rand_range(0, 1)
	var mob: Mob = mob_scene.instance()
	var mob_type = get_random_mob_type()
	mob.spriteFrames = mob_type["spriteFrames"] 
	mob.global_position = $PathFollow2D.global_position
	
	mob.speed = mob_type["speed"]
	mob.hp = mob_type["hp"]
	mob.dmg = mob_type["dmg"]
	main_node.add_child(mob)
	
	

func _on_SpawnTimer_timeout():
	spawn_random_mob()
