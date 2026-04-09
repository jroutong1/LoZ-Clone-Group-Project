extends Area2D


func _on_body_entered(body):
	body.pickup_sword()
	queue_free()
