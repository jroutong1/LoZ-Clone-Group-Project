extends Node2D

@export var location = Vector2()
@export var player_location = Vector2()
@export var face_dir = ""
@export var trigger_code = ""
var count = 0

var touching_door = false

func _ready():
	set_process(false)

func _process(_delta):
	if touching_door:
		if Input.is_action_pressed("move_up"):
			$Arrow.visible = false
			$Arrow.stop()
			door_entered()
			count += 1

func _on_enter_body_entered(_body):
	touching_door = true
	set_process(true)


func _on_enter_body_exited(_body):
	touching_door = false
	set_process(false)

func door_entered():
	touching_door = false
	set_process(false)
	Game.move_room(location, player_location, face_dir, trigger_code, count)


func _on_near_body_entered(_body):
	$Arrow.visible = true
	$Arrow.play("Point")


func _on_near_body_exited(_body):
	$Arrow.visible = false
	$Arrow.stop()
