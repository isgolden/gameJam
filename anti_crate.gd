extends CharacterBody2D

@export var moveVelDamp := 0.75
@export var maxHVel : float = 150
@onready var size = $CollisionShape2D.get_shape().get_rect().size;
@onready var pArea = $Area2D

var noPortal = true

func _process(delta: float) -> void:
	var isPush = false
	velocity.y += 50
	var col = pArea.get_overlapping_bodies()
	for i in col:
		if "canBeRemoved" in i:
			i.queue_free()
			queue_free()
		if i is not CharacterBody2D:
			continue
		if "size" in i:
			if i.position.y + i.size.y > position.y and i.position.y < position.y + size.y:
				if (i.position.x < position.x and i.velocity.x > 0) or (i.position.x > position.x and i.velocity.x < 0):
					isPush = true
					velocity.x = i.velocity.x
	if(!isPush and is_on_floor()):
		velocity.x *= moveVelDamp
	if abs(velocity.x) > maxHVel:
		velocity.x = maxHVel*sign(velocity.x)
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if !(body is CharacterBody2D):
		return;
	
