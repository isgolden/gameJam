extends Area2D

signal channel_emit(name : String, state : bool)

@onready var sprite := $buttonSprite

var bodiesOn = 0;

func _on_body_entered(body: Node2D) -> void:
	bodiesOn += 1;
	sprite.frame = 1
	channel_emit.emit(name, true)

func _on_body_exited(body: Node2D) -> void:
	bodiesOn -= 1;
	if (bodiesOn == 0):
		sprite.frame = 0
	channel_emit.emit(name, false)
