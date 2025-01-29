extends Node2D

var message = [
	""
]

var typing_speed = null
var read_time = 2

var current_message = 0
var display = ""
var current_char = 0
	
func start_dialogue():
	if typing_speed == null:
		typing_speed = (3.5/len(message[0])) + 0.05
	print()
	current_message = 0
	display = ""
	current_char = 0
	
	$next_char.set_wait_time(typing_speed)
	$next_char.start()
func _input(event):
	if event.is_action_pressed("SPACE"):
		display = message[0]
		current_char = len(message[0])
		$Label.text = display
		$AudioStreamPlayer.pitch_scale = randf_range(2.8, 3.4)
		$AudioStreamPlayer.volume_db = -15
		$AudioStreamPlayer.play()
		read_time = 2.5
		
func _on_next_char_timeout():
	if (current_char < len(message[current_message])):
		var next_char = message[current_message][current_char]
		display += next_char
		$Label.text = display
		if(next_char != " " and next_char != "." and next_char != ","):
			$AudioStreamPlayer.pitch_scale = randf_range(3.4, 3.8)
			$AudioStreamPlayer.play()
		
		current_char += 1
	else:
		$next_char.stop()
		$end.set_wait_time(read_time)
		$end.start()

func _on_end_timeout():
	get_tree().call_group("group_name","ResetTalk")
	queue_free()
