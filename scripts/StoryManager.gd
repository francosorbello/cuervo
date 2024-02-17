extends Node2D

@export var start_timer : float = 0.5
@export var initial_dialogue : Dialogue
@export var crow : PackedScene 

@export_category("Debug")
@export var skip_dialogue : bool = false

var started : bool = false
var do_spawn_crow : bool = false

func _on_trigger_area_body_entered(body:Node2D):
	if(started):
		return
	if(body.is_in_group("player")):
		started = true
		if(skip_dialogue):
			$UI/DialogueUI.dialogue_finished.emit()
			return
		
		await get_tree().create_timer(start_timer).timeout

		$Player.story_zoom_in()
		$Player.story_disable_controller()
		
		$SongManager.play()

		$UI/DialogueUI.start_dialogue(initial_dialogue)
		

func test_zoom_out():
	await get_tree().create_timer(3).timeout
	$Player.story_zoom_out()


func _on_dialogue_ui_dialogue_finished():
	_start_attack()
	pass # Replace with function body.


func _start_attack():
	$CrowDeathCircle.set_start_position($Player.global_position)
	$TileMap.set_layer_enabled(1, false)
	$CrowDeathCircle.start_circle()
	# await get_tree().create_timer($CrowDeathCircle.obstacle_anim_timer).timeout
	$Player.enable_controller()
	
	# _spawn_first_crow()
	do_spawn_crow = true

func _spawn_first_crow():
	do_spawn_crow = false
	var crow_pos = $SpeakingCrow.global_position
	var _crow = crow.instantiate()
	add_child(_crow)
	# await get_tree().process_frame
	_crow.global_position = crow_pos
	# await _crow.ready
	_crow.do_dive()
	# $SpeakingCrow.queue_free()
	$SpeakingCrow.toggle(false)

func _physics_process(delta):
	if(do_spawn_crow):
		_spawn_first_crow()
