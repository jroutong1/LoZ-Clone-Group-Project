extends StaticBody2D

func on_killed():
	$Sprite.visible = false
	$".."/".."/"..".set_physics_process(false)
	$Collision.queue_free()
	$Hitbox.queue_free()
	$Die.emitting = true
	$"Delete Timer".start()


func _on_delete_timer_timeout():
	$".."/".."/"..".queue_free()
