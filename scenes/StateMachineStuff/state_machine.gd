extends Node

var current_state

var states = {} # Contains all possible states
var stack = []

"""
Create a dictionary of all children states and set current state
to the first state passed in
"""
func _ready() -> void:
	for state in get_children(): # Each state is a node of this object
		state.set_fsm(self) # States hold a reference to machine
		states[state.get_name()] = state
		if current_state:
			remove_child(state)
		else:
			current_state = state

func change_to(state_name):
	stack.append(current_state.get_name())
	set_state(state_name)
	
func set_state(state_name):
	remove_child(current_state)
	current_state = states[state_name]
	add_child(current_state)
	current_state.enter()

func back():
	if stack.length > 0:
		set_state(stack.pop_back())
