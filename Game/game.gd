extends Node

var ui_scene = preload("res://Game/ui.tscn")
var camera_scene = preload("res://Objects/camera.tscn")
var ui_instance
var camera_instance

var lives = 3

var cam_target
var player_target
var face_target

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	camera_instance = camera_scene.instantiate()
	add_child(camera_instance)
	
	ui_instance = ui_scene.instantiate()
	add_child(ui_instance)
	
	get_tree().paused = true
	ui_instance.intro()

func game_start():
	get_tree().paused = false

func game_resume():
	get_tree().paused = false

func on_hurt():
	lives -= 1
	ui_instance.set_lives(lives)
	if lives >= 0:
		on_death()

func on_death():
	get_tree().paused = true

func pickup_sword():
	ui_instance.show_sword()

func move_room(coords, player_coords, player_dir):
	get_tree().paused = true
	cam_target = coords
	player_target = player_coords
	face_target = player_dir
	ui_instance.entrance_fade_out()
func move_camera():
	camera_instance.position = cam_target
	camera_instance.target_position = cam_target
	$"../World/Player".position = player_target
	match face_target:
		"N": $"../World/Player/Sprite".play("North")
		"E": $"../World/Player/Sprite".play("East")
		"S": $"../World/Player/Sprite".play("South")
		"W": $"../World/Player/Sprite".play("West")
	cam_target = 0
	player_target = 0
	ui_instance.entrance_fade_in()
