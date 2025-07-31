extends Node2D
 
signal body_entered(body : Node2D, to : int, rot: float)

var id : int = -1
var to : int = -1;
var timeStamp = -1;




func _on_portal_area_body_entered(body: Node2D) -> void:
	body_entered.emit(body,to,rotation,position-body.position)
