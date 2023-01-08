extends Camera2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var decay = 0.8  # How quickly the shaking stops [0, 1].
export var max_offset = Vector2(6, 3)  # Maximum hor/ver shake in pixels.
export var max_roll = 0.1  # Maximum rotation in radians (use sparingly).
var trauma = 0.0  # Current shake strength.
var trauma_power = 2  # Trauma exponent. Use [2, 3].


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if trauma:
		trauma = max(trauma - decay * delta, 0)
		shake()
		
func shake(): 
	var amount = pow(trauma, trauma_power)
	offset.x = max_offset.x * amount * rand_range(-1,1)
	offset.y = max_offset.y * amount * rand_range(-1,1)

func _physics_process(delta):
	var player: KinematicBody2D = get_node("/root/Main/Player")

	var target_position = player.transform.origin
	
	var direction = (target_position - position).normalized()
	
	position = position.linear_interpolate(target_position, delta * 5)

func add_trauma(amount):
	trauma = min(trauma + amount, 1.0)

func _on_Player_player_hit(dmg):
	add_trauma(1.0)
	pass # Replace with function body.
