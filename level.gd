extends Node2D

@onready var pHandle := $portalHandler
@onready var upC := $portalHandler/upCheck
@onready var downC := $portalHandler/downCheck


var playerScene := preload("res://player.tscn")
var portalScene := preload("res://portal.tscn")
var crateScene := preload("res://crate.tscn")
var antiCrateScene := preload("res://anti_crate.tscn")

func placePortal(portal : Node2D) -> void:
	var pS = portal.get_node("portalArea/portalShape").get_shape().get_rect().size
	pS = pS.rotated(portal.rotation)
	var off = Vector2(pS.x,0)
	if(abs(pS.x) < abs(pS.y)):
		off.y = pS.y
		off.x = 0
	var inv = Vector2(off.y,off.y)
	upC.position = portal.position + sign(inv)
	downC.position = portal.position + sign(inv)
	upC.target_position = off/2 + sign(inv)
	downC.target_position = -off/2 + sign(inv)
	
	upC.force_raycast_update()
	downC.force_raycast_update()
	if upC.is_colliding() and downC.is_colliding():
		queue_free()
	if upC.is_colliding():
		portal.position = -off/2+upC.get_collision_point()
	if downC.is_colliding():
		portal.position = off/2+downC.get_collision_point()
	
	portal.body_entered.connect(entered_portal)
	
	portal.id = pHandle.get_child_count()
	print(pHandle.get_child_count())
	if((pHandle.get_child_count()&1) == 1):
		portal.to = portal.id-1
		pHandle.get_child(portal.id-1).to = portal.id
	pHandle.add_child(portal)

func entered_portal(body: Node2D, to: int, rot: float, off : Vector2, id : int) -> void:
	if to == -1 or "noPortal" in body or body is TileMapLayer or body.lastPortal == id:
		return;
	var toP = pHandle.get_child(to)
	var angDiff = angle_difference(toP.rotation,rot)+PI
	if body.tempVel.length() > body.velocity.length():
		body.velocity = body.tempVel.rotated(-angDiff)
	else:
		body.velocity = body.velocity.rotated(-angDiff)
	body.position = toP.position
	body.lastPortal = to
	body.rePortalTim = body.rePortalDel

func _ready() -> void:
	var player = playerScene.instantiate()
	player.placePortal.connect(placePortal);
	add_child(player)
	var testCrate := crateScene.instantiate()
	testCrate.position.x += 100
	add_child(testCrate)
	var tACrate := antiCrateScene.instantiate()
	tACrate.position.x += 500
	add_child(tACrate)
