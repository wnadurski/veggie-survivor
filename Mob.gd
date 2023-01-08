extends KinematicBody2D
class_name Mob


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var speed = 150
export var dmg = 20
export var spriteFrames: SpriteFrames
export var hp = 40
export var weapon_immunity_ms = 1000
export var seeds = [1]


var player: KinematicBody2D
var velocity = Vector2.ZERO

export var knockback_speed = 300
var knockback = Vector2.ZERO
var knockback_diminish = 2000
var weapon_last_hit = {}

onready var seedRootNode = get_node("/root/Main")

onready var seedScene =  preload("res://Seed.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("/root/Main/Player")
	if spriteFrames:
		$AnimatedSprite.frames = spriteFrames


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _process(delta):
	if knockback != Vector2.ZERO:
		var previous_knockback_dir = knockback.normalized()
		knockback -= knockback.normalized() * knockback_diminish * delta
		if knockback.normalized().dot(previous_knockback_dir) < 0:
			knockback = Vector2.ZERO
		

func _physics_process(delta):
	var target = player.position
	
	var direction = (target - position).normalized()
	var target_velocity = direction * speed
	
	velocity = velocity.linear_interpolate(target_velocity, delta * 10)
	
	var final_velocity = velocity + knockback
	
	velocity = move_and_slide(final_velocity)
	
func damage(weapon_name: String, amount: int):
	var now = OS.get_ticks_msec()
	var previous = weapon_last_hit.get(weapon_name, 1)
	
	if now - previous > weapon_immunity_ms:
		knockback += -(player.position - position).normalized() * knockback_speed
		hp = max(0, hp - amount)
		weapon_last_hit[weapon_name] = now
		$AnimationPlayer.play("damage")
		if hp == 0:
			$DeathTimer.connect("timeout", self, "die")
			$DeathTimer.start()

func die():
	var seeds_count = seeds[randi() % seeds.size()]
	
	for i in range(seeds_count):
		var new_seed: RigidBody2D = seedScene.instance()
		new_seed.apply_central_impulse(Vector2(randf() * rand_range(100, 200), randf() * rand_range(100, 200)))
		new_seed.position = position
		seedRootNode.add_child(new_seed)
	
	queue_free()
