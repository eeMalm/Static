extends Node2D

@export var ObjSprite : CompressedTexture2D
@export var BombSprite : CompressedTexture2D

var IsHover = false
var IsMove = false
func _ready():
	print("spawned")
	$Sprite2D.texture = ObjSprite
	$Sprite2D2.texture = ObjSprite
	if ObjSprite == BombSprite:
		$Sprite2D.hframes = 16
		$Sprite2D2.hframes = 16
		$AnimationPlayer.play("Exlpode")
		$Explosion.play()
		$BombTimer.start()

func _on_bomb_timer_timeout():
	get_tree().call_group("TheWorld","Endgame")
	
func _input(event):
	if event.is_action_pressed("LMB") and IsHover:
			IsMove = !IsMove
			if !IsMove:
				self.position.y += 10
				$Sprite2D2.position.y = 5
				
			$Clunk.pitch_scale = randf_range(0.4, 0.8)
			$Clunk.volume_db = randf_range(-30.0, -20.0)
			$Clunk.play()

func _on_area_2d_mouse_entered():
	IsHover = true
	
func _on_area_2d_mouse_exited():
	IsHover = false

	
func _process(delta):
	if(IsMove):
		self.position = get_viewport().get_mouse_position()
		self.position.y -= get_viewport().get_visible_rect().size.y / 2
		self.position.x -= get_viewport().get_visible_rect().size.x / 2
		
		self.position /= 4.3

		
		self.position.y -= 10
		$Sprite2D2.position.y = 10






