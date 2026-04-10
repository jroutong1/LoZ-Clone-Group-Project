extends StaticBody2D

func chat(duration):
	$"Chat Timer".wait_time = duration
	$Sprite.play("Chit Chat")
	$"Chat Timer".start()


func _on_chat_timer_timeout():
	$Sprite.stop()
