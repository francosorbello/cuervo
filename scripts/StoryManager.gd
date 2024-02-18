extends Node2D
## Node that manages all story related tasks, like dialogues, spawning, etc.

# @export var start_timer : float = 0.5
@export var initial_dialogue : Dialogue ## Dialogue to display on first game loop.
@export var crow : PackedScene 

@export_category("Debug")
@export var skip_dialogue : bool = false ## skips the dialogue and goes directly to fighting.

var started : bool = false
var story_finished : bool = false

## Starts the story.
func start_story(body:Node2D):
	# breakpoint
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
	toggle_obstacles(false)
	$CrowDeathCircle.set_start_position($Player.global_position)
	$CrowDeathCircle.start_circle()
	# await get_tree().create_timer($CrowDeathCircle.obstacle_anim_timer).timeout
	$Player.enable_controller()
	$Player.story_zoom_out()

## Spawns a crow in the position of the crow that talks to the player.
func _spawn_first_crow():
	story_finished = false
	var crow_pos = $SpeakingCrow.global_position
	var _crow = crow.instantiate()
	_crow.name = "FirstCrow"
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

## Toggles tutorial obstacles, like the map limits.
func toggle_obstacles(value : bool):
	$TileMap.set_layer_enabled(1, value)

	if(get_node_or_null("CrowTutorial")):
		$CrowTutorial.queue_free()
	
	if(get_node_or_null("CrowTutorial2")):
		$CrowTutorial2.queue_free()

func _on_player_player_died():
	reset_game()
	# $UI/GameUI.transition_in()

func reset_game():
	started = false
	
	await $UI/GameUI/GameUI.toggle(true)
	
	var first_node = get_node_or_null("FirstCrow")
	if(first_node):
		first_node.queue_free()
	
	$SpeakingCrow.toggle(true)
	$CrowDeathCircle.reset()
	
	$Player.reset()
	
	toggle_obstacles(true)
	
	$Player.enable_controller()
	
