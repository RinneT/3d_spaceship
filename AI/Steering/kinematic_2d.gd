extends Node
class_name Kinematic2D

var position: Vector2
var orientation: float
var velocity: Vector2
var rotation: float 

# Returns a copy of this object
func clone() -> Kinematic2D:
	var dup: Kinematic2D = Kinematic2D.new()
	dup.position = position
	dup.orientation = orientation
	dup.velocity = velocity
	dup.rotation = rotation
	return dup
