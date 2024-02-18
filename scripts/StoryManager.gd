extends Node2D

@export var start_timer : float = 0.5
@export var initial_dialogue : Dialogue
@export var crow : PackedScene 

@export_category("Debug")
@export var skip_dialogue : bool = false

var started : bool = false
var story_finished : bool = false

func start_story(body:Node2D):
	if(started):
		return
	if(body.is_in_group("player")):

		if(body.global_position.y > $TriggerArea.global_position.y):
			return

		started = true
		if(skip_dialogue):
			$UI/DialogueUI.dialogue_finished.emit()
			return
		
		#await get_tree().create_timer(start_timer).timeout

		$Player.story_zoom_on($Marker2D.global_position)
		$Player.story_disable_controller()
		
		$SongManager.play()

		$UI/DialogueUI.start_dialogue(initial_dialogue)
		

func test_zoom_out():
	await get_tree().create_timer(3).timeout
	$Player.story_zoom_out()


func _on_dialogue_ui_dialogue_finished():
	story_finished = true
	_start_attack()
	pass # Replace with function body.


func _start_attack():
	$CrowDeathCircle.set_start_position($Player.global_position)
	$TileMap.set_layer_enabled(1, false)
	$CrowDeathCircle.start_circle()
	# await get_tree().create_timer($CrowDeathCircle.obstacle_anim_timer).timeout
	$Player.enable_controller()
	

func _spawn_first_crow():
	story_finished = false
	var crow_pos = $SpeakingCrow.global_position
	var _crow = crow.instantiate()
	add_child(_crow)
	_crow.global_position = crow_pos
	_crow.do_dive()
	
	$SpeakingCrow.toggle(false)


func _on_trigger_area_body_exited(body):
	start_story(body)
	pass # Replace with function body.

func _physics_process(_delta):
	if(story_finished):
		_spawn_first_crow()