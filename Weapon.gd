extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var weapon_name = "weapon"
export var dmg = 20
export var crit_chance = 0.3
export var crit_max_size = 1.5
export var crit_min_size = 0.5

export var max_scale = Vector2(2, 1.5)

var dmg_modifier = 0

onready var seed_tracker = get_node("/root/Main/SeedTracker")

var stopped = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$HitTimer.start()
	seed_tracker.connect("seeds_changed", self, "on_seeds_change")

func on_seeds_change(new_seeds):
	dmg_modifier = new_seeds
	
	var step = 0.03
	
	scale.x = min(max_scale.x, 1.0 + dmg_modifier * step) * sign(scale.x)
	scale.y = min(max_scale.y, 1.0 + dmg_modifier * step / (max_scale.x / max_scale.y))

func _physics_process(delta):
	if stopped:
		return
	var bodies: Array = get_overlapping_bodies()
	for _body in bodies:
		var body: Mob = _body
		var crit = 0
		var roll = randf()
		if roll <= crit_chance:
			crit += rand_range(crit_min_size, crit_max_size) * dmg
		
		body.damage(weapon_name, dmg + crit + dmg_modifier)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_HitTimer_timeout():
	if stopped:
		return
	$AnimationPlayer.play("Attack")
	
func stop_attacking():
	stopped = false
	$HitTimer.stop()
