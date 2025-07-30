extends CharacterBody2D

@export var GRAVITY :float = 50
@export var SPEED :float = 20
@export var JUMP_FORCE : float = 1000

func _physics_process(delta: float) -> void:
	var dir = float(Input.is_action_pressed("right"))-float(Input.is_action_pressed("left"))
	if dir == 0 or sign(velocity.x) != sign(dir):
		velocity.x *= 0.75;
	velocity.x += dir*SPEED
	velocity.y += GRAVITY
	if Input.is_action_just_pressed("jump"):
		velocity.y = -JUMP_FORCE
	move_and_slide()
