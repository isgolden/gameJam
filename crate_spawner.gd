extends AnimatedSprite2D

signal create_crate(crate : Node2D)

var crateScene = preload("res://crate.tscn")
var id = -1
var off := Vector2()

func spawnNew()->void:
	play()

func _on_animation_finished() -> void:
	var temp = crateScene.instantiate()
	temp.position += offset
	temp.spawnId = id;
	create_crate.emit(temp)
	frame = 0
