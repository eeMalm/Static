extends Sprite2D
var SiezeIsHover
var ChatIsHover
var InterrogateIsHover
var QuestionIsHover
var StopIsHover
var GoIsHover

func _input(event):
	if event.is_action_pressed("LMB"):
		if SiezeIsHover == true :
			Sieze()
		if ChatIsHover == true :
			Chat()
		if InterrogateIsHover == true :
			Interrogate()
		if QuestionIsHover == true :
			Question()
		if StopIsHover == true :
			Stop()
		if GoIsHover == true :
			Go()


func _on_area_2d_seize_mouse_entered():
	SiezeIsHover = true
	
func _on_area_2d_mouse_exited():
	SiezeIsHover = false

func _on_area_2d_chat_mouse_entered():
	ChatIsHover = true

func _on_area_2d_chat_mouse_exited():
	ChatIsHover = false
	
func _on_area_2d_interrogate_mouse_entered():
	InterrogateIsHover = true

func _on_area_2d_interrogate_mouse_exited():
	InterrogateIsHover = false

func _on_area_2d_question_mouse_entered():
	QuestionIsHover = true


func _on_area_2d_question_mouse_exited():
	QuestionIsHover = false
	
func _on_area_2d_stop_mouse_entered():
	StopIsHover = true
		
func _on_area_2d_stop_mouse_exited():
	StopIsHover = false

func _on_area_2d_go_mouse_entered():
	GoIsHover = true
	
func _on_area_2d_go_mouse_exited():
	GoIsHover = false

func Sieze():
	print("seizure")
	get_tree().call_group("group_name","QueueDialogue", "S")
func Chat():
	print("Chate")
	get_tree().call_group("group_name","QueueDialogue", "C")
func Interrogate():
	print("interger")
	get_tree().call_group("group_name","QueueDialogue", "I")
func Question():
	print("questiane banane")
	get_tree().call_group("group_name","QueueDialogue", "Q")
func Stop():
	print("Stope")
	get_tree().call_group("group_name","QueueDialogue", "K")
func Go():
	print("Goo")
	get_tree().call_group("group_name","QueueDialogue", "G")
