class_name SteeringOutput2D
extends Node

var linear: Vector2 # desired linear velocity
var angular: float # desired rotational velocity

# Print the Steering values to console
func print() -> void:
	print("Linear: " + str(linear) + " | Angular: " + str(angular))
