extends Button



func _on_StartButton_pressed():
	$StartPressed.play()
	get_tree().change_scene("res://Main.tscn")
	
