extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var background: Background = get_node("/root/Main/InfiniteBackground/Background")
var backgroundScene = preload("res://background.tscn")
onready var camera: Camera2D = get_node("/root/Main/PlayerCamera")

onready var matrix = [background, null, null, null]


# Called when the node enters the scene tree for the first time.
func _ready():
	handle_new_background(background)
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#var tilemap: TileMap = background.get_node("bottom")
	#var rect = tilemap.map_to_world()
	
	var pos = camera.get_camera_position()
	
	#print("rect ", rect, "camera", pos)

func handle_new_background(background: Background):
	background.connect("visibility_change", self, "_on_Background_visibility_change", [background])
	
	
func remove_background(background: Background):
	var current_index = matrix.find(background)
	if current_index != -1:
		matrix[current_index] = null
	background.queue_free()

func is_left(background: Background):
	var current_index = matrix.find(background)
	if current_index == -1:
		return false
	if current_index % 2 == 0:
		return true
	return false
	
func is_right(background: Background):
	var current_index = matrix.find(background)
	if current_index == -1:
		return false
	
	return !is_left(background)
	
func is_top(background: Background):
	var current_index = matrix.find(background)
	if current_index == -1:
		return false
	if current_index < 2:
		return true
	return false
	
func is_bot(background: Background):
	var current_index = matrix.find(background)
	if current_index == -1:
		return false
	
	return !is_top(background)
	

func has_left(background: Background):
	var current_index = matrix.find(background)
	if current_index == -1:
		return false
	
	if is_left(background):
		return false
	
	return matrix[current_index - 1] != null
	
func has_right(background: Background):
	var current_index = matrix.find(background)
	if current_index == -1:
		return false
	
	if is_right(background):
		return false
	
	return matrix[current_index + 1] != null
	
func has_top(background: Background):
	var current_index = matrix.find(background)
	if current_index == -1:
		return false
	
	if is_top(background):
		return false
	
	return matrix[current_index - 2] != null
	
	
func has_bot(background: Background):
	var current_index = matrix.find(background)
	if current_index == -1:
		return false
	
	if is_bot(background):
		return false
	
	return matrix[current_index + 2] != null
	
func shift_right():
	var b1 = matrix[1]
	var b2 = matrix[3]
	
	if b1:
		b1.queue_free()
	if b2: 
		b2.queue_free()
		
		
	matrix[1] = matrix[0]
	matrix[3] = matrix[2]
	matrix[0] = null
	matrix[2] = null
	
func shift_left():
	var b1 = matrix[0]
	var b2 = matrix[2]
	
	if b1:
		b1.queue_free()
	if b2: 
		b2.queue_free()
		
	matrix[0] = matrix[1]
	matrix[2] = matrix[3]
	matrix[1] = null
	matrix[3] = null
	
func shift_up():
	var b1 = matrix[0]
	var b2 = matrix[1]
	
	if b1:
		b1.queue_free()
	if b2: 
		b2.queue_free()
		
	matrix[0] = matrix[2]
	matrix[1] = matrix[3]
	matrix[2] = null
	matrix[3] = null
	
func shift_down():
	var b1 = matrix[2]
	var b2 = matrix[3]
	
	if b1:
		b1.queue_free()
	if b2: 
		b2.queue_free()
		
	matrix[2] = matrix[0]
	matrix[3] = matrix[1]
	matrix[0] = null
	matrix[1] = null
	
func _on_Background_visibility_change(side, is_visible, background: Background):
	var current_index = matrix.find(background)
	
	#if side == "full" and is_visible == false:
	#	remove_background(background)
		
	if side == "left" and is_visible and not has_left(background):
		print("adding left")
		var new_background: Background = backgroundScene.instance()		
		add_child(new_background)
		handle_new_background(new_background)
		
		new_background.position = background.position - Vector2(background.tile_map_rect.size.x, 0)
		
		print("matrix before", matrix)
		if(is_left(background)):
			shift_right()
		
		if(is_top(background)):
			matrix[0] = new_background
		else:
			matrix[2] = new_background
			
		print("matrix after", matrix)
			
	if side == "right" and is_visible and not has_right(background):
		print("adding right")
		var new_background: Background = backgroundScene.instance()		
		add_child(new_background)
		handle_new_background(new_background)
		
		new_background.position = background.position + Vector2(background.tile_map_rect.size.x, 0)
		
		print("matrix before", matrix)
		if(is_right(background)):
			shift_left()
		
		if(is_top(background)):
			matrix[1] = new_background
		else:
			matrix[3] = new_background
		print("matrix after", matrix)
		
	if side == "top" and is_visible and not has_top(background):
		print("adding top")
		var new_background: Background = backgroundScene.instance()		
		add_child(new_background)
		handle_new_background(new_background)
		
		new_background.position = background.position - Vector2(0, background.tile_map_rect.size.y)
		
		print("matrix before", matrix)
		if(is_top(background)):
			shift_down()
		
		if(is_left(background)):
			matrix[0] = new_background
		else:
			matrix[1] = new_background
		print("matrix after", matrix)
			
	if side == "bottom" and is_visible and not has_bot(background):
		print("adding bottom")
		var new_background: Background = backgroundScene.instance()		
		add_child(new_background)
		handle_new_background(new_background)
		
		new_background.position = background.position + Vector2(0, background.tile_map_rect.size.y)
		
		print("matrix before", matrix)
		if(is_bot(background)):
			shift_up()
		
		if(is_left(background)):
			matrix[2] = new_background
		else:
			matrix[3] = new_background
		print("matrix after", matrix)
			
		
