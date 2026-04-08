extends CharacterBody2D
@onready var path_follow_2d: PathFollow2D = $Path2D/PathFollow2D

var stargrid: AStarGrid2D

@export var speed = 0.1

func _physics_process(delta: float) -> void:
	path_follow_2d.progress_ratio += delta * speed
	
	move_and_slide()
