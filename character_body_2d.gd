extends CharacterBody2D

signal placePortal(portal : Node2D)

var portalScene = preload("res://portal.tscn")

@onready var vSize = get_viewport().get_visible_rect().size

@onready var shootRay = $shootCast

@export var GRAVITY :float = 100
@export var SPEED :float = 40
@export var JUMP_FORCE : float = 1500
@export var maxXSpeed : float = 1000

func _physics_process(delta: float) -> void:
	var dir = float(Input.is_action_pressed("right"))-float(Input.is_action_pressed("left"))
	if dir == 0 or sign(velocity.x) != sign(dir):
		velocity.x *= 0.75;
	if abs(velocity.x) < maxXSpeed:
		velocity.x += dir*SPEED
	velocity.y += GRAVITY
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -JUMP_FORCE
	if(Input.is_action_just_pressed("shoot")):
		var colRes = shootRay.get_collision_point()
		var colNorm = shootRay.get_collision_normal()
		var temp = portalScene.instantiate();
		temp.position = colRes;
		temp.rotation = atan2(colNorm.y,colNorm.x)
		placePortal.emit(temp);
	move_and_slide()
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		shootRay.rotation = atan2(event.position.y-vSize.y/2,event.position.x-vSize.x/2)
