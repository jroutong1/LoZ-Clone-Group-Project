extends Node

var ui_scene = preload("res://Game/ui.tscn")
var camera_scene = preload("res://Objects/camera.tscn")
var ui_instance
var camera_instance

var lives = 3

var cam_target
var player_target
var face_target
var room_target
var room_target_count

func _process(_delta):
	if Input.is_action_just_pressed("exit_game"):
		get_tree().quit()

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

func game_resume_room():
	get_tree().paused = false
	room_logic(room_target, room_target_count)
	#room_target = ""
	#room_target_count = 0

func game_end():
	get_tree().paused = true
	#await Input.action_press("ui_cancel")
	await get_tree().create_timer(3.0).timeout
	get_tree().quit()

func on_hurt():
	if $"../World/Player".has_broken_key == false and $"../World/Player".has_key == true:
		ui_instance.shatter_key()
		$"../World/Player".has_broken_key = true
	lives -= 1
	ui_instance.set_lives(lives)
	if lives <= 0:
		on_death()

func on_death():
	get_tree().paused = true
	ui_instance.outro_over()

func pickup_sword():
	ui_instance.show_sword()

func pickup_key():
	ui_instance.show_key()

func move_room(coords, player_coords, player_dir, trigger="", uses=0):
	get_tree().paused = true
	cam_target = coords
	player_target = player_coords
	face_target = player_dir
	ui_instance.entrance_fade_out()
	room_target = trigger
	room_target_count = uses
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
	ui_instance.hide_dialogue()

func room_logic(trig, use):
	match trig:
		"": pass
		"NPCROOM":
			if $"../World/Player".has_sword == false and $"../World/Player".has_key == false and $"../World/Player".has_broken_key == false:
				match use: 
					0:
						$"../World/Entities/Old Man".chat(3.0)
						ui_instance.say_dialogue("Take this sword and bring me the key to return home!", 3.0)
					1:
						$"../World/Entities/Old Man".chat(2.0)
						ui_instance.say_dialogue("Hurry up and take the sword..!", 2.0)
					2:
						$"../World/Entities/Old Man".chat(3.0)
						ui_instance.say_dialogue("Maybe you can get the key without the sword...", 3.0)
					_:
						$"../World/Entities/Old Man".chat(2.8)
						ui_instance.say_dialogue("Shouldn't you be looking for the key?", 2.8)
			
			elif $"../World/Player".has_sword == true and $"../World/Player".has_key == false and $"../World/Player".has_broken_key == false:
				$"../World/Entities/Old Man".chat(2.6)
				ui_instance.say_dialogue("Bring me the key to return home...", 2.6)
			
			#WINS
			elif $"../World/Player".has_sword == true and $"../World/Player".has_key == true and $"../World/Player".has_broken_key == false:
				#WIN CONDITION SWORD AND KEY
				$"../World/Level/Exit".queue_free()
				ui_instance.outro_good(5)
				$"../World/Entities/Old Man".chat(3.1)
				ui_instance.say_dialogue("You found the key...? Wonderful... It's time to go home...", 3.1)
			elif $"../World/Player".has_sword == true and $"../World/Player".has_key == true and $"../World/Player".has_broken_key == true:
				#WIN CONDITION SWORD AND BROKEN KEY
				$"../World/Level/Exit".queue_free()
				ui_instance.outro_bad(5)
				$"../World/Entities/Old Man".chat(3.5)
				ui_instance.say_dialogue("You broke the key...!? I'm afraid you'll be stuck here for a long time...", 3.5)
			elif $"../World/Player".has_sword == false and $"../World/Player".has_key == true and $"../World/Player".has_broken_key == false:
				#WIN CONDITION ONLY KEY
				$"../World/Level/Exit".queue_free()
				ui_instance.outro_good(5)
				$"../World/Entities/Old Man".chat(3.3)
				ui_instance.say_dialogue("You got the key without my sword? Truly... Excellent...", 3.3)
			elif $"../World/Player".has_sword == false and $"../World/Player".has_key == true and $"../World/Player".has_broken_key == true:
				#WIN CONDITION ONLY BROKEN KEY
				$"../World/Level/Exit".queue_free()
				ui_instance.outro_bad(5)
				$"../World/Entities/Old Man".chat(3.7)
				ui_instance.say_dialogue("You broke the key...!? Maybe if you took the sword, things would be different...", 3.7)
