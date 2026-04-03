extends Node2D

var target_position = Vector2(128.0, 192.0)
var i_paused = false

func _ready():
	$UI.visible = true
	position = Vector2(128.0, 192.0)


func _process(delta):
	if position != target_position:
		position.x = move_toward(position.x, target_position.x, delta*500)
		position.y = move_toward(position.y, target_position.y, delta*500)
	elif i_paused:
		get_tree().paused = false
		i_paused = false

func on_player_exit_camera(_body):
	target_position = get_target_camera()
	get_tree().paused = true
	i_paused = true

func get_target_camera():
	var _x = $"..".global_position.x - 128 #players x position - offset
	var _y = $"..".global_position.y - 192 #players y position - offset
	if position.y < $"..".global_position.y:
		_y = $"..".global_position.y - 112 #exception for uneven screen
	var _xx = (round(_x/256)*256) + 128
	var _yy = (round(_y/176)*176) + 192
	return Vector2(_xx, _yy)
