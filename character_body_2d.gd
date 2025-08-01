extends CharacterBody2D

signal placePortal(portal : Node2D)

var lastPortal : int = -1

var portalScene = preload("res://portal.tscn")

@onready var size = $playerShape.get_shape().get_rect().size
@onready var vSize = get_viewport().get_visible_rect().size

@onready var shootRay = $shootCast

@export var GRAVITY :float = 100
@export var SPEED :float = 40
@export var JUMP_FORCE : float = 1500
@export var maxXSpeed : float = 1000
@export var rePortalDel : int = 10

var tempVel : Vector2
var rePortalTim : int = rePortalDel

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
	if velocity.x+velocity.y > 10:
		tempVel = velocity
	move_and_slide()
	if rePortalTim <= 0:
		lastPortal = -1
	if lastPortal != -1:
		rePortalTim-=1
	else:
		rePortalTim = rePortalDel
		 
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		shootRay.rotation = atan2(event.position.y-vSize.y/2,event.position.x-vSize.x/2)
