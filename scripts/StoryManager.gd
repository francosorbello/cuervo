extends Node2D

@export var start_timer : float = 0.5
@export var initial_dialogue : Dialogue

var started : bool = false


func _on_trigger_area_body_entered(body:Node2D):
    if(started):
        return
    if(body.is_in_group("player")):
        print("story started")
        started = true
        await get_tree().create_timer(start_timer).timeout
        $Player.story_zoom_in()
        $Player.story_disable_controller()
        $UI/DialogueUI.start_dialogue(initial_dialogue)
        

func test_zoom_out():
    await get_tree().create_timer(3).timeout
    $Player.story_zoom_out()