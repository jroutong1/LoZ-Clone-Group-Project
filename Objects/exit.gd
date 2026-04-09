extends Area2D

@export var location = Vector2()
@export var player_location = Vector2()
@export var face_dir = ""

func _on_body_entered(_body):
	Game.move_room(location, player_location, face_dir)
