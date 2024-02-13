class_name State extends Node

var state_machine: StateMachine = null
var state_owner: Node = null

func setup(s_owner: Node, s_machine: StateMachine):
	self.state_machine = s_machine
	self.state_owner = s_owner

func enter():
	pass

func update(delta: float):
	pass

func pyhsics_update(delta: float):
	pass

func exit():
	pass

func can_exit() -> bool:
	return true
