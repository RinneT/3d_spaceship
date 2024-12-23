extends Node
class_name AbstractSteering

# Steering behaviour scripts for 2D space based on
# "Artifical Intelligence for Games" by Ian Millington and John Funge
# A few customizations have been made.
# E.g. the steering behaviours will always return the desired velocity,
# without care for the characters boundaries.
# Capping must be conducted separately

var character: Kinematic2D
var target: Kinematic2D

func get_steering() -> SteeringOutput2D:
	push_error("Called get_steering in AbstractSteering class! Instantiate a behaviour class instead!")
	return SteeringOutput2D.new()
