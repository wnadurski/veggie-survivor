extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(NodePath) var player_path = "/root/Main/Player"

onready var player: KinematicBody2D = get_node(player_path)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	if not player:
		return
	
	var player_diff = (player.position - position)
		
	if player_diff.length() <= 70.0:
		self.applied_force = player_diff.normalized() * 2000
	else:
		self.applied_force = Vector2.ZERO


func _on_Area2D_body_entered(body):
	body.add_seed()
	queue_free()
