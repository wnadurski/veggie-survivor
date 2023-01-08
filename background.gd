extends Node2D
class_name Background

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal visibility_change

var full_visibility: bool = false

var tile_map_rect: Rect2

var side_visibilities = {
	"right": false,
	"left": false,
	"top": false,
	"bottom": false
}

var neighbours = {
	"right": null,
	"left": null,
	"top": null,
	"bottom": null
}

# Called when the node enters the scene tree for the first time.
func _ready():
	var tilemap: TileMap = $bottom
	var tile_rect = tilemap.get_used_rect()
	var topLeft = tilemap.map_to_world(tile_rect.position)
	var size = tilemap.map_to_world(tile_rect.size)
	
	tile_map_rect = Rect2(topLeft, size)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func change_full_visibility(is_visible: bool):
	full_visibility = is_visible
	emit_signal("visibility_change", "full", is_visible)
	
func change_side_visibility(side: String, is_visible: bool):
	side_visibilities[side] = is_visible
	emit_signal("visibility_change", side, is_visible)


func _spawn_left():
	pass # Replace with function body.


func _spawn_bottom():
	pass # Replace with function body.


func _on_FullVisibility_screen_entered():
	change_full_visibility(true)


func _on_FullVisibility_screen_exited():
	change_full_visibility(false)


func _on_LeftVisibility_screen_entered():
	change_side_visibility("left", true)


func _on_LeftVisibility_screen_exited():
	change_side_visibility("left", false)


func _on_BottomVisibility_screen_entered():
	change_side_visibility("bottom", true)


func _on_BottomVisibility_viewport_exited(viewport):
	change_side_visibility("bottom", false)


func _on_TopVisibility_screen_entered():
	change_side_visibility("top", true)


func _on_TopVisibility_screen_exited():
	change_side_visibility("top", false)


func _on_RightVisibility_screen_entered():
	change_side_visibility("right", true)


func _on_RightVisibility_screen_exited():
	change_side_visibility("right", false)
