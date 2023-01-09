extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal player_hit
signal player_dead
signal seed_collected

export var speed = 300
export var knockback_speed = 600
var knockback = Vector2.ZERO
var knockback_diminish = 2000
var dead = false


var scythe_left_x = -18

func die():
	dead = true
	emit_signal("player_dead")

# Called when the node enters the scene tree for the first time.
func _ready():
	$Scythe.scale.x = -1
	$Scythe.position.x = scythe_left_x * (-1)
	connect("player_dead", $Scythe, "stop_attacking")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func add_seed():
	emit_signal("seed_collected")
	$SeedCollected.play()

func _physics_process(delta):
	if dead:
		return
	var direction = Vector2.ZERO
	
	var knockback_opposite = -knockback.normalized()
	knockback -= knockback.normalized() * knockback_diminish * delta
	
	if(knockback.normalized() == knockback_opposite) :
		knockback = Vector2.ZERO
		
	if Input.is_action_pressed("move_left"):
		direction += Vector2.LEFT
	if Input.is_action_pressed("move_down"):
		direction += Vector2.DOWN
	if Input.is_action_pressed("move_right"):
		direction += Vector2.RIGHT
	if Input.is_action_pressed("move_up"):
		direction += Vector2.UP
		
	direction = direction.normalized()
	
	
	var movement = (direction * speed + knockback).clamped(speed)
	
	move_and_slide(movement)
	
	var cumulated_knockback_direction = Vector2.ZERO
	var cumulated_dmg = 0
	
	for i in get_slide_count():
		var collision: KinematicCollision2D = get_slide_collision(i)
		
		if collision.collider.get_collision_layer_bit(2):
			var collider: Mob = collision.collider
			var knockback_direction = collision.normal.normalized()
			cumulated_dmg += collider.dmg
			cumulated_knockback_direction = (cumulated_knockback_direction + knockback_direction).normalized()
			
	if cumulated_dmg != 0:
		emit_signal("player_hit", cumulated_dmg)
		$DamagePlayer.play()
		
	knockback += cumulated_knockback_direction * knockback_speed
	
	var sprite: Sprite = $Sprite
	
	if direction.length() > 0:
		$AnimatedSprite.play("move")
	else:
		$AnimatedSprite.play("default")
		$AnimatedSprite.stop()
	
	if direction.x != 0:
		var xDir = sign(direction.x)
		$AnimatedSprite.scale = Vector2(xDir, 1)
		
		$Scythe.scale.x = -xDir * abs($Scythe.scale.x)
		$Scythe.position.x = scythe_left_x * (-xDir)
	
	
