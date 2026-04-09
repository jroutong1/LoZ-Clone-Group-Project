extends CharacterBody2D

#signal just_hurt

const SPEED = 70.0
enum STATE {ACTIONABLE, ATTACKING}
var state = STATE.ACTIONABLE
enum DIR {NORTH, EAST, SOUTH, WEST}
var aim_dir = DIR.SOUTH
var has_sword = false

func _ready():
	#just_hurt.connect(on_hurt)
	$Sprite.play("North")

func _physics_process(_delta):
	match state:
		STATE.ACTIONABLE:
			var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
			if direction:
				velocity = direction * SPEED
				set_aim(direction)
				$Sprite.play()
			else:
				$Sprite.stop()
				velocity.x = move_toward(velocity.x, 0, SPEED)
				velocity.y = move_toward(velocity.y, 0, SPEED)
			
			if Input.is_action_just_pressed("attack"):
				if has_sword:
					state = STATE.ATTACKING
					$"Attack/Pre-Delay".start()
		STATE.ATTACKING:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.y = move_toward(velocity.y, 0, SPEED)
	move_and_slide()


func set_aim(dir): #wont work on controller without extra effort because stick is analog and will output different values
	match Vector2(snappedf(dir.x, 0.000001), snappedf(dir.y, 0.000001)):
		Vector2(0.0, 1.0): #south
			$Sprite.animation = "South"
			aim_dir = DIR.SOUTH
		Vector2(0.0, -1.0): #north
			$Sprite.animation = "North"
			aim_dir = DIR.NORTH
		Vector2(1.0, 0.0): #east
			$Sprite.animation = "SouthEast"
			aim_dir = DIR.EAST
		Vector2(-1.0, 0.0): #west
			$Sprite.animation = "SouthWest"
			aim_dir = DIR.WEST
		Vector2(0.707107, -0.707107): #northeast
			$Sprite.animation = "NorthEast"
			aim_dir = DIR.EAST
		Vector2(-0.707107, -0.707107): #northwest
			$Sprite.animation = "NorthWest"
			aim_dir = DIR.WEST
		Vector2(-0.707107, 0.707107): #southwest
			$Sprite.animation = "SouthWest"
			aim_dir = DIR.WEST
		Vector2(0.707107, 0.707107): #southeast
			$Sprite.animation = "SouthEast"
			aim_dir = DIR.EAST


func _on_attack_delay_timeout():
	state = STATE.ACTIONABLE
	$Attack.visible = false
	#$Attack/Sword.set_deferred("monitoring", false)#hitbox deactivate
	#$Attack/Sword/Hitbox.set_deferred("disabled", true)


func _on_attack_pre_delay_timeout():
	$Sprite.stop()
	$Attack.visible = true
	match aim_dir:
		DIR.NORTH: $Attack/Slash.play("North")
		DIR.EAST: $Attack/Slash.play("East")
		DIR.SOUTH: $Attack/Slash.play("South")
		DIR.WEST: $Attack/Slash.play("West")
	$Attack/Delay.start()
	#$Attack/Sword.set_deferred("monitoring", true)#hitbox activate
	#$Attack/Sword/Hitbox.set_deferred("disabled", false)

func on_hurt():
	Game.on_hurt()

func pickup_sword():
	has_sword = true
	Game.pickup_sword()


func _on_sword_body_entered(_body):
	$Attack/Sword/Particles.emitting = true
