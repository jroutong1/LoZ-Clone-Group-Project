extends CanvasLayer


func intro():
	$Screen.play("Fade In")
	$"Intro Timer".start()


func _on_intro_timer_timeout():
	Game.game_start()

func set_lives(num):
	match num:
		3:
			$Heart1.visible = true
			$Heart2.visible = true
			$Heart3.visible = true
		2:
			$Heart1.visible = true
			$Heart2.visible = true
			$Heart3.visible = false
		1:
			$Heart1.visible = true
			$Heart2.visible = false
			$Heart3.visible = false
		0:
			$Heart1.visible = false
			$Heart2.visible = false
			$Heart3.visible = false

func show_sword():
	$Sword.visible = true
	$Z.visible = true

func show_key():
	$Key.visible = true

func entrance_fade_out():
	$Screen.play("Fade Out")
	$"Room FadeOut Timer".start()

func _on_room_fade_out_timer_timeout():
	Game.move_camera()

func entrance_fade_in():
	$Screen.play("Fade In")
	$"Room FadeIn Timer".start()

func _on_room_fade_in_timer_timeout():
	Game.game_resume_room()

func hide_dialogue():
	$Dialogue.visible = false

func say_dialogue(message, time):
	$Dialogue.text = message
	$Text.play("Roll")
	$Text.speed_scale = 1/time
	$Dialogue.visible = true
	
