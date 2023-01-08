extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var HP = 100

signal hp_changed

onready var deathScreen = get_node("/root/Main/UI/DeathScreen")
onready var player = get_node("/root/Main/Player")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func change_hp(amount: float):
	HP = clamp(HP + amount, 0, 100)
	emit_signal("hp_changed", HP)
	if HP <= 0:
		deathScreen.get_node("AnimationPlayer").play("fade_in")
		player.die()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if HP <= 0 and Input.is_action_pressed("ui_accept"):
		get_tree().reload_current_scene()


func _on_Player_player_hit(dmg: float):
	change_hp(-dmg)
