extends Node2D
var Asked = false
var DialogueBox = preload("res://Dialogue.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("Intro")
	$IntroTimer.start()
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_intro_timer_timeout():
	var DBox = DialogueBox.instantiate()
	add_child(DBox)
	DBox.position.y = 40
	DBox.position.x = 0
	DBox.typing_speed = 0.3
	DBox.message = ["You have summoned TODD, bold move kiddo."]
	DBox.start_dialogue()
	
	$Timer2.start()
	

func _on_timer_2_timeout():
	var DBox = DialogueBox.instantiate()
	add_child(DBox)
	DBox.position.y = 40
	DBox.position.x = 0
	DBox.typing_speed = 0.3
	DBox.message = ["So now the choice is yours, join me, or perish."]
	DBox.start_dialogue()
	Asked = true
	
func QueueDialogue(query):
	print("sent" + query)
	if Asked:
		if query != "G" and query != "K":
			var DBox = DialogueBox.instantiate()
			add_child(DBox)
			DBox.position.y = 40
			DBox.position.x = 0
			DBox.typing_speed = 0.3
			DBox.message = ["Your silly buttons dont work on me"]
			DBox.start_dialogue()

		if query == "K":
			get_tree().quit()
		if query == "G":
			var DBox = DialogueBox.instantiate()
			add_child(DBox)
			DBox.position.y = 40
			DBox.position.x = 0
			DBox.typing_speed = 0.3
			DBox.message = ["Welcome, son, we've waited long and hard for an inside man. STATIC will fall soon, then America, then Russia."]
			DBox.start_dialogue()
			$Timer3.start()
		



func _on_timer_3_timeout():
	get_tree().quit()
