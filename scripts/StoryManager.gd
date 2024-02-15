extends Node2D

var started : bool = false


func _on_trigger_area_body_entered(body:Node2D):
    if(started):
        return
    if(body.is_in_group("player")):
        started = true
        $Player.zoom_in()
